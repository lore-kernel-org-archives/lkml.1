Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbXDKPn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbXDKPn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXDKPn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:43:26 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40286 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbXDKPnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:43:25 -0400
Date: Wed, 11 Apr 2007 17:43:07 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "menu" versus "menuconfig" -- they're *both* a bad idea
In-Reply-To: <Pine.LNX.4.64.0704110546220.11664@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <Pine.LNX.4.61.0704111742340.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0704111059190.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0704110509200.11343@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0704111134300.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0704110546220.11664@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 05:47, Robert P. J. Day wrote:
>> On Apr 11 2007 05:25, Robert P. J. Day wrote:
>> >On Wed, 11 Apr 2007, Jan Engelhardt wrote:
>> >> On Apr 11 2007 03:58, Robert P. J. Day wrote:
>> >>
>> >> A CONFIG_EMBEDDED bug. This should perhaps be changed.
>> >> Or at best, deactivate the ---> part when it's N.
>> >
>> >  i'm not sure what you mean by "bug".  if what you mean is that it's
>> >a bad choice of menu layout, i agree.  but what's happening there
>> >is not technically "wrong" or "buggy" in the sense that it's
>> >perfectly legal based on the current design of "menuconfig".
>>
>> Of course.
>
>ok, just checking that we were actually agreeing with one another.
>:-)

Wait, I forgot something:

Of course, patches are welcome. :-P



Jan
-- 
