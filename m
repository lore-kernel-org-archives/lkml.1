Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbZKOVWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbZKOVWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 16:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZKOVWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 16:22:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:30076 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZKOVWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 16:22:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=X/U1Bg7IDdReQZci1M9riNCIrZ0IwQU5+b/LAIp9TCt/oMpapfG0WthPGA179UY8oG
         Msl7MEUcXw+9aZtBUy0bBWqApatNUWeby93egquUYI/WqKPNB8GBRGZ/9FTc3JDvVLOf
         LRfeJZob8dzlnYKv7UhUZx6aS+/ZsoKsVq5Qs=
Message-ID: <4B007110.3060905@gmail.com>
Date: Sun, 15 Nov 2009 22:22:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091112 SUSE/3.0.0-1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?SWJhbiBSb2Ryw61ndWV6?= <iban.rodriguez@ono.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: intelfb maintainer
References: <1258319857.6556.59.camel@invitado-laptop>
In-Reply-To: <1258319857.6556.59.camel@invitado-laptop>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2009 10:17 PM, Iban Rodríguez wrote:
>     I have found a problem in the intelfb driver. I've tried to send an
> e-mail to Sylvain Meyer (maintainer) but I've received the mail back
> because of 'user unknown'. Could you tell me who I can send the report?

You can use:
./scripts/get_maintainer.pl -f ./drivers/video/intelfb/

It gives many people.

-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
