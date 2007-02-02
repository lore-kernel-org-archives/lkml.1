Return-Path: <linux-kernel-owner+w=401wt.eu-S1946088AbXBBVWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946088AbXBBVWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946089AbXBBVWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:22:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40958 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946088AbXBBVWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:22:13 -0500
Date: Fri, 2 Feb 2007 13:18:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert "fix typo in geode_configre()@cyrix.c"
Message-Id: <20070202131854.d5ea9de7.akpm@osdl.org>
In-Reply-To: <20070202151236.GN7582@csclub.uwaterloo.ca>
References: <20070202062941.GB3754@stusta.de>
	<20070202000543.c3664ecc.akpm@linux-foundation.org>
	<20070202151236.GN7582@csclub.uwaterloo.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 10:12:36 -0500
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Fri, Feb 02, 2007 at 12:05:43AM -0800, Andrew Morton wrote:
> > On Fri, 2 Feb 2007 07:29:41 +0100 Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > Linus, please revert commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba
> > > 
> > 
> > Yup.
> > 
> > That discussion seems to have died.  The 2.6.19 code looks rather silly, but
> > presumably it passed someone's testing at some stage.
> 
> The discussion ended because the last patch seemed to be correct to
> everyone involved in the discussion.  At least that is my understanding.
> Of course I am just one of the users affected by the patch.

The discussion ended with me asking for someone to send a patch.  That
hasn't happened yet.  I don't want to have to troll through 20-30 messages
and try to work out what patch we ended up with - that's the way in which
mistakes occur.

Linus has now reverted e4f0ae0ea63caceff37a13f281a72652b7ea71ba.  Now,
please, could someone send a patch against either current -git or against
2.6.19?  One which includes a descriptin of what it does, and why.

Thanks.
