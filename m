Return-Path: <linux-kernel-owner+w=401wt.eu-S1763491AbXK2RRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763491AbXK2RRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762912AbXK2RRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:17:11 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:28813 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762742AbXK2RRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yji5N+fhtYvwrqThKRzlDh1ieToS/7q6NKrAk0BDLsBy4FafZoaBhnwI+lnoNyCuLrTuKl2ROnVBEvRWKnFa+Hyg/2x51jGckff9kybbtoE7LoqL6ib8JWfiSylv2p3YWJ4Xg2H4RvsMUGc6URHzAtaQC0xlboiaO77A7CJS6gM=
Message-ID: <5501535d0711290917r16a16b0dx36669de89f829231@mail.gmail.com>
Date: Thu, 29 Nov 2007 18:17:07 +0100
From: "Bjoern Olausson" <lkmlist@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata NCQ blacklist entry
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <4731B5DD.1060203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com>
	 <4731B5DD.1060203@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/07, Tejun Heo <htejun@gmail.com> wrote:
>
> Thanks.  We're currently trying to find out what's actually going on
> with all these drives.  At first, drives which got blacklisted aren't
> many and made sense (had other problems with NCQ, etc..) but with new
> generation drives from many vendors showing the same symptom, we aren't
> too sure now.
>
> I'll keep your email in my todo list and add the drive to the blacklist
> once the problem is verified.
>
> Thanks.

Something new on the NCQ front?
Just asking if you need someone to test some of your ideas?

I got the "WDC WD740ADFD-00NLR1"

by the way, and OT, did the Plextor DVD-RW drive reach you, Tejun?
