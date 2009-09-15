Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZIOTfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZIOTfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZIOTfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:35:12 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:54591 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754943AbZIOTfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:35:11 -0400
Date: Tue, 15 Sep 2009 15:32:28 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, travis@sgi.com
Subject: Re: [GIT PULL] percpu for v2.6.32
In-Reply-To: <4AAFE9B2.1030006@kernel.org>
Message-ID: <alpine.DEB.1.10.0909151531490.3340@V090114053VZO-1>
References: <4AAF411C.2040501@kernel.org> <alpine.DEB.1.10.0909151510010.3340@V090114053VZO-1> <4AAFE9B2.1030006@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Tejun Heo wrote:

> Christoph Lameter wrote:
> > On Tue, 15 Sep 2009, Tejun Heo wrote:
> >
> >> * All arches except for ia64 have been converted to use the new
> >>   allocator.
> >
> > Any plans for this? The percpu operations patchset
> > requires the new allocator to work on all platforms and I am wondering
> > when I should repost the set.
>
> I've been trying to get a cheap second hand itanium machine but itanic
> really seems to have sunk pretty well.  It's almost impossible to find
> one here.  I guess I'll have to bite the bullet and do it remotely.
> There gotta be one with serial console and power control hooked up
> somewhere in the company lab.  I'll try to locate one.

Maybe Mike knows of some way to get access to one?

