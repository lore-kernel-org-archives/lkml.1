Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0APMWS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 07:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546Ab0APMWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 07:22:17 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:52227 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0APMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 07:22:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oX93w8tLmUdEsDa4ttN1DUn/b4Sy+UR32EtyWuDRWeaUtAGOt2i3XRR/KkJBdlRlIU
         l3zj41MQO9fffh0gFMp1YRMWP8rPovbF0ZVjdHG+yNoAXQyRvCTOwTz+7tPpA1yE2BHc
         lAx4obJg0AMOcURyinTJusMCGhXyZACypju/o=
Message-ID: <4B51AF74.3020006@gmail.com>
Date: Sat, 16 Jan 2010 13:22:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-17.1 Thunderbird/3.0
MIME-Version: 1.0
To: Dominik Brodowski <linux@dominikbrodowski.net>
CC: linux-pcmcia@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: broken pcmcia_bus_match for dynids
References: <4B4DBF9D.7040002@gmail.com> <20100116120410.GB20984@comet.dominikbrodowski.net>
In-Reply-To: <20100116120410.GB20984@comet.dominikbrodowski.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 01:04 PM, Dominik Brodowski wrote:
> Well, as dynid->id.cisfile is never set, it is still NULL

Ah, I overlooked that. Thanks for pointing out.

-- 
js
