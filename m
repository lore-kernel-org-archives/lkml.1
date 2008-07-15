Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbYGOSFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbYGOSFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYGOSFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:05:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41704 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYGOSFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:05:34 -0400
Message-ID: <487CE6CB.9090405@zytor.com>
Date: Tue, 15 Jul 2008 11:04:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> So if the version were to be date-based, instead of releasing 2.6.26, 
> maybe we could have 2008.7 instead. Or just increment the major version 
> every decade, the middle version every year, and the minor version every 
> time we make a release. Whatever.
> 

The Altera Quartus tool series have version 8.x for all the versions 
released in 2008; they've followed that scheme since 2002.   I think it 
took until 2005 until anyone outside Altera noticed, but it was 
reasonably clean.  Presumably it will be 10.x in 2010.

Clearly, the 2. prefix has long outlived its usefulness as far as Linux 
is concerned, and probably the 6 as well.  I personally don't think 
two-digit numbers are a big problem, although three-digit numbers *are*, 
which is probably why a lot of software has x.xx format version identifiers.

	-hpa
