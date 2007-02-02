Return-Path: <linux-kernel-owner+w=401wt.eu-S1945930AbXBBPMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945930AbXBBPMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945929AbXBBPMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:12:37 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:57366 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945930AbXBBPMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:12:36 -0500
Date: Fri, 2 Feb 2007 10:12:36 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert "fix typo in geode_configre()@cyrix.c"
Message-ID: <20070202151236.GN7582@csclub.uwaterloo.ca>
References: <20070202062941.GB3754@stusta.de> <20070202000543.c3664ecc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202000543.c3664ecc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 12:05:43AM -0800, Andrew Morton wrote:
> On Fri, 2 Feb 2007 07:29:41 +0100 Adrian Bunk <bunk@stusta.de> wrote:
> 
> > Linus, please revert commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba
> > 
> 
> Yup.
> 
> That discussion seems to have died.  The 2.6.19 code looks rather silly, but
> presumably it passed someone's testing at some stage.

The discussion ended because the last patch seemed to be correct to
everyone involved in the discussion.  At least that is my understanding.
Of course I am just one of the users affected by the patch.

--
Len Sorensen
