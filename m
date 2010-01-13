Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703Ab0AMLfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab0AMLfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487Ab0AMLfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:35:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:16710 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab0AMLfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:35:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ToF6pGf6x5LeF9SlwFz1qsMtEvzcZTBioiVEQQ3y1G8xuxoHfhuo42rlGZ89Arc/g1
         EveEejotqHCe3ufwD7KVDPeCBsN1w1QXel9rciOXR5lE3RiXvRrmkTrsvGanUybvKwCR
         eBO3xA2a7+iMNY/FCC4ZJ2jDWdNLB7KFUYc3w=
Message-ID: <4B4DAFEC.5090705@gmail.com>
Date: Wed, 13 Jan 2010 12:35:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-17.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: mchehab@redhat.com, hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] media: video/cx18, fix potential null dereference
References: <1263113806-7532-1-git-send-email-jslaby@suse.cz>	 <1263253709.4116.1.camel@palomino.walls.org>  <4B4C5CEF.5060601@gmail.com> <1263382347.3057.11.camel@palomino.walls.org>
In-Reply-To: <1263382347.3057.11.camel@palomino.walls.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 12:32 PM, Andy Walls wrote:
> If you don't mind a delay of until Sunday or so to get the patch applied
> to the V4L-DVB tree, I can take the patch and work it in my normal path
> through Mauro.  Let me know.

I have no problem with that.

thanks,
-- 
js
