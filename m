Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYJLBjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYJLBjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 21:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYJLBjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 21:39:05 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:59499 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYJLBjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 21:39:04 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=BoGAJat747ilacEGilwA:9 a=dnd2T5A7aT3u5p58tfXl0E4GFHYA:4
Message-ID: <48F1552F.7090600@shaw.ca>
Date: Sat, 11 Oct 2008 19:38:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>, petkovbb@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: locking improvements
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <200810111756.37278.bzolnier@gmail.com> <20081011175617.GX19428@kernel.dk> <200810112046.23557.bzolnier@gmail.com>
In-Reply-To: <200810112046.23557.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> The work has already been done and it is a wortwhile work.  The risk is
> quite low (this is the statement based on rather deep understanding of
> IDE subsystem, the complete audit of all code-paths affected and all the
> testing experiences from Scalex86/me).
> 
> Moreover the patch won't be merged after few months of extra testing.
> 
> I feel that you still keep on questioning the point of improving IDE
> and insist on putting it into "bug-fixes only" mode.  If this is really
> the case I'm completely uninterested in discussing it any further.

What, exactly, is the point of making more than bug-fix-only changes to 
the IDE code today, when we have libata around which is a much better 
code base to work from? I'm afraid it still escapes me. I don't mean to 
denigrate the work that you and other people working on IDE are doing, 
but can't help but think there would be more productive outlets for it..
