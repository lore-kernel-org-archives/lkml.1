Return-Path: <linux-kernel-owner+w=401wt.eu-S934195AbYCFWeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195AbYCFWeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYCFWdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:33:33 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:39544 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbYCFWda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:33:30 -0500
X-Greylist: delayed 1640 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 17:33:30 EST
Date: Thu, 6 Mar 2008 23:05:58 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Pawel Plociennik <paplociennik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306220558.GA18202@citd.de>
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com> <20080306212028.GB1747@elf.ucw.cz> <47D06265.8030305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D06265.8030305@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.03.2008 13:30, H. Peter Anvin wrote:
> Pavel Machek wrote:
>>
>> This really should be in kernel, I should not have to partition my
>> disk to get booting to few different distros.
>
> Use a small initramfs.  That's the Right Thing to do in the first place.

And what's with the people that just don't have such a beast?

I use monolithic kernels, know the device-name of my root-fs and i'm 
proud of it. ;-)



Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

