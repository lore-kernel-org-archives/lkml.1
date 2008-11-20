Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYKTGLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYKTGLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 01:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYKTGL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 01:11:28 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58827 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751971AbYKTGL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 01:11:27 -0500
Date: Thu, 20 Nov 2008 01:11:17 -0500
From: Theodore Tso <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: adilger@sun.com, linux-ext4@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] ext4: fix some s64 printing warnings
Message-ID: <20081120061117.GA8610@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>, adilger@sun.com,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	ppc-dev <linuxppc-dev@ozlabs.org>
References: <20081112111049.68c604ff.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112111049.68c604ff.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 11:10:49AM +1100, Stephen Rothwell wrote:
> A powerpc ppc64_defconfig build of Linus' current tree produces these
> warnings:

Hi Stephen,

Thanks for submitting the patch!  As it turns out, a patch that was
pretty much identical to yours was submitted by Alexander Beregalov
and was merged into mainline as of 2.6.28-rc5, as commit ID ba8292e2.

Regards,

						- Ted
