Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbXDLQoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbXDLQoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXDLQoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:44:11 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:52066 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXDLQoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:44:09 -0400
Date: Thu, 12 Apr 2007 18:41:22 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Egmont Koblinger <egmont@uhulinux.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
In-Reply-To: <461E5212.8070807@zytor.com>
Message-ID: <Pine.LNX.4.61.0704121840350.14441@yvahk01.tjqt.qr>
References: <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>
 <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com>
 <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com>
 <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu>
 <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com>
 <20070412091120.GA15666@uhulinux.hu> <461E5212.8070807@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 12 2007 08:36, H. Peter Anvin wrote:
> Egmont Koblinger wrote:
>
>> > Besides, would it not make more sense to have a single table with the
>> > width information, if you insist on having one, instead of multiple
>> > ones?
>> 
>> I've been thinking on it and I'm not sure which one the right way is. The
>> reason for choosing this was probably that this way information that is
>> not
>> used by the code can be omitted by the compiler.
>
> Then let's leave it out of the source.

I however will put this into my rpm if it works/isstable.


Jan
-- 
