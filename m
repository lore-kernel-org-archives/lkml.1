Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYKENzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYKENzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYKENzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:55:00 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:55563 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYKENy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:54:59 -0500
Date: Wed, 5 Nov 2008 07:54:39 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com
Subject: Re: Git next: Second stage of cpu_alloc patches
In-Reply-To: <20081104195205.fe1bf62b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0811050753120.11867@quilx.com>
References: <Pine.LNX.4.64.0811042053510.31638@quilx.com>
 <20081104195205.fe1bf62b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Andrew Morton wrote:

> On Tue, 4 Nov 2008 20:56:52 -0600 (CST) Christoph Lameter <cl@linux-foundation.org> wrote:
>
>> The second stage of the cpu_alloc patchset can be pulled from
>>
>> kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc_stage2
>
> Please send the patches for review.  Always.

Well okay can we define a process how to get patches merged with the -next 
tree involved? It was nice when you handled all of this but the last 
version of the cpu_alloc was thrown out of mm because of a -next conflict 
and so it seemed better to go to the source than risk this again.

> I've forgotten how this whole cpu_alloc thing worked and now it's all
> stuffed away in some git tree somewhere.  Oh well, whee...

Ok so post a patchset to lkml and at the same time offer a git tree?

