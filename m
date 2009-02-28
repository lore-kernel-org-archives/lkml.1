Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbZB1Xzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbZB1Xzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 18:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZB1Xzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 18:55:31 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47183 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZB1Xza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 18:55:30 -0500
Date: Sat, 28 Feb 2009 23:55:26 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mike@compulab.co.il, linux-kernel@vger.kernel.org
Subject: Re: checkpatch --file warns about p0 patch
Message-ID: <20090228235526.GA6023@shadowen.org>
References: <49A2B0A5.8050905@compulab.co.il> <20090223144312.GC22617@shadowen.org> <20090223150405.ce90a2c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223150405.ce90a2c0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 03:04:05PM -0800, Andrew Morton wrote:
> On Mon, 23 Feb 2009 14:43:12 +0000
> Andy Whitcroft <apw@canonical.com> wrote:
> 
> > Hmm, that should already be fixed in the version Andrew Morton has.
> 
> Hmm, all of these:
> 
> checkpatch-make-in_atomic-ok-in-the-core.patch
> checkpatch-do-not-warn-about-p0-patches-when-checking-files.patch
> checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers.patch
> checkpatch-pointer-type-star-may-have-modifiers-following.patch
> checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch
> checkpatch-extend-attribute-testing-to-all-modifiers.patch
> checkpatch-add-__ref-as-a-sparse-modifier.patch
> checkpatch-version-028.patch
> 
> apart from perhaps checkpatch-add-__ref-as-a-sparse-modifier.patch look
> like bugfixes.  So I suppose we should slip them into 2.6.29, yes?

Yes those are all bugfixes.  If we can get them in that would be good.

-apw
