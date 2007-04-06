Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbXDFRCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbXDFRCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXDFRCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:02:50 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:10231 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328AbXDFRCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:02:49 -0400
Date: Fri, 06 Apr 2007 09:52:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.9 won't compile
In-reply-to: <fa.wFTrjBlmoNpWJlHvvdovpz3pV2I@ifi.uio.no>
To: =?UTF-8?B?UGVkcm8gTXVsbG9yIEppbcOpbmV6?= <pmullor@skynet.be>
Cc: linux-kernel@vger.kernel.org
Message-id: <46166CA3.6080406@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.wFTrjBlmoNpWJlHvvdovpz3pV2I@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pedro Mullor Jiménez wrote:
> Dear all,
> 
> I downloaded version 2.6.9 of the kernel from kernel.org
> I went throught menuconfig, importing the configuration of my current
> 2.6.15-28-686.
> 
> I then tried to compile it but the compilation exits with an error
> (below).
> 
> I also tried to do make mrproper, got rid of the .config file, made
> menuconfig again without importing anything, and when compiling it
> failed again.
> 
> The reason for me to use this kernel is because I have a VIA VT82C
> 693A/598/686 chipset and I suffer from perf problems (which google says
> only happen since 2.6.10).
> 
> Might I request to be personally CC'ed in the answers/comments posted in
> response to this post ?

Your compiler is probably too new to be able to compile 2.6.9. You'd 
likely be better off trying the latest kernels and making a detailed 
report of the problems you're having with it..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

