Return-Path: <linux-kernel-owner+w=401wt.eu-S2993009AbXBQSCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993009AbXBQSCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993008AbXBQSCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:02:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:20444 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993007AbXBQSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=D4kri1IQTBpLlicKewC9xNxaOBuSxTRpSzbi8WvMQ2QCn5MjMl4GvmAzep7SI4HtRYMZJ0b37qZrk/P08bkufn2gWLx8fZk26y2EdEQAaFGMtFUpzPjp8vJyv2dimiCIFJjmyYhrgmXaWfvbgg1HamnCUfXhNOEcd9LBxKgSXV0=
Date: Sat, 17 Feb 2007 20:59:18 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070217175918.GA10307@cvg>
References: <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org> <20070216085706.GA22868@2ka.mipt.ru> <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org> <20070216160525.GA21160@2ka.mipt.ru> <2c0942db0702160853s18f650ccsa7270c047d94a41b@mail.gmail.com> <20070216165854.GA18522@2ka.mipt.ru> <20070216202036.GA10190@cvg> <20070217100159.GA15971@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217100159.GA15971@2ka.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 01:02:00PM +0300, Evgeniy Polyakov wrote:
[... snipped ...]

| Yes, I only proposed to change what Ingo has right now - although it is
| usable, but it does suck, but since overall syslet design is indeed good
| it does not suffer from possible interface changes - so I said that it
| can be trivially changed in that regard that until it is committed
| anything can be done to extend it.
| 
| -- 
| 	Evgeniy Polyakov
| 

I think Evgeniy - you are right! For times of research _changing_ a lot
of things is almost a low. syslets are in test area and why should we
bound ourself in survey of best. If something in syslets is sucks so
lets change it as early as possible. Of course I mean no more interface
changing after some _commit_ point (and that should be Linus decision).

-- 

		Cyrill

