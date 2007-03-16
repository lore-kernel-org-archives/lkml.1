Return-Path: <linux-kernel-owner+w=401wt.eu-S965787AbXCPRps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965787AbXCPRps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965792AbXCPRpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:45:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:7610 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965787AbXCPRpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=WUg56F+gKcdt5ATulPBUYZKQRB6V0nNR4lS3XkmGju6vLJtVQ6cuQNbFN/+++IdIsVa8PeyngopoH3phP0uihn5oPICQUmVkY2GFQOmiZF8TWQzudTxmxQums6KWG7/9EkbvqFHZxFJqNhPZxXRL+wcYEuuyzwGAcJrbY8CflxU=
Message-ID: <45FAD77A.1070709@googlemail.com>
Date: Fri, 16 Mar 2007 18:44:26 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got *bad* news. Bug described here
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#0889
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165
probably leaked into mainline. 

Fsck!

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-console.log

Takashi, unfortunately this bug isn't fixed
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1684

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
