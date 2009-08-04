Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbZHDIAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbZHDIAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZHDIAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:00:47 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:45000 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZHDIAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:00:46 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2009 04:00:46 EDT
Message-ID: <4A77E9A7.8030004@gefanuc.com>
Date: Tue, 04 Aug 2009 08:56:23 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Greg K-H <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [patch 0/5] [ANNOUNCE] VME Bus drivers and framework for Linux
References: <20090803210054.GA28430@kroah.com>
In-Reply-To: <20090803210054.GA28430@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg K-H wrote:
> Hi all,
>
> Here's 5 patches from Martyn Welch that adds VME Bus support to the
> kernel.
>
> Martyn took the time and merged the three different existing
> implementations for Linux together into something that works, and got
> the proper legal agreements from all of the affected parties to release
> the code properly.
>   
Just for the record - I realized that two were a forks of the 
vmelinux.org codebase. I picked the most developed fork, the original 
having not been ported to the 2.6.x tree. I have also used the other 
fork in the past, I don't believe there is much if anything that is 
worth taking from that.

Martyn

-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
