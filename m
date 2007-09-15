Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbXIOAdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbXIOAdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 20:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759526AbXIOAd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 20:33:26 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:33889 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759400AbXIOAdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 20:33:25 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Mel Gorman <mel@skynet.ie>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
References: <20070911060349.993975297@sgi.com>
	<200709121246.08833.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0709121607140.4204@schroedinger.engr.sgi.com>
	<200709140720.06537.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0709141053110.15813@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0709141114130.15965@schroedinger.engr.sgi.com>
Date: Sat, 15 Sep 2007 02:33:20 +0200
In-Reply-To: <Pine.LNX.4.64.0709141114130.15965@schroedinger.engr.sgi.com>
	(Christoph Lameter's message of "Fri, 14 Sep 2007 11:15:16 -0700
	(PDT)")
Message-ID: <87ps0klqcv.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> On Fri, 14 Sep 2007, Christoph Lameter wrote:
>
>> an -ENOMEM. Given the quantities of pages on todays machine--a 1 G machine 
>
> s/1G/1T/ Sigh.
>
>> has 256 milllion 4k pages--and the unmovable ratios we see today it 
>
> 256k for 1G.

256k == 64 pages for 1GB ram or 256k pages == 1Mb?

MfG
        Goswin
