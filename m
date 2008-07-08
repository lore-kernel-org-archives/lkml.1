Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYGHHW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYGHHW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYGHHWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:22:22 -0400
Received: from mail.atmel.fr ([81.80.104.162]:65396 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYGHHWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:22:21 -0400
Message-ID: <487315A3.40302@atmel.com>
Date: Tue, 08 Jul 2008 09:22:11 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: webmaster@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
       hpa@kernel.org
Subject: Re: git pull through http / git
References: <48724130.5050501@atmel.com> <alpine.LNX.1.10.0807071840470.8248@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0807071840470.8248@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt :
> On Monday 2008-07-07 18:15, Nicolas Ferre wrote:
> 
>> Hi,
>>
>> I see differences when I use git to a git.kernel.org between the one I fetch
>> using http protocol and the one shown through the gitweb interface.
>>
>> I cloned (or git remote add) the mmc tree and my config shows this url :
>> url = http://www.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git
>>
>> but I see updates in :
>> http://git.kernel.org/?p=linux/kernel/git/drzeus/mmc.git;a=summary
>> I cannot get.
> 
> I don't think many care about http downloading, just because it is 
> available as such.
> git:// and rsync:// are available though and should be usable even 
> without the http info that needs to be constantly refreshed when one 
> wants to use http....

If only I had the choice...

You certainly know why I am using http. This feature is very useful for 
me and I was wondering why it was out of sync with the web interface.

Regards,
-- 
Nicolas Ferre

