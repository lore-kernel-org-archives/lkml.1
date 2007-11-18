Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbXKRUSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbXKRUSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 15:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXKRUR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 15:17:58 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35459
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752128AbXKRUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 15:17:57 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken in 2.6.23.1)
Date: Sun, 18 Nov 2007 14:17:49 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Greg KH <greg@kroah.com>, WANG Cong <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
References: <200711032351.52977.rob@landley.net> <200711161600.23745.rob@landley.net> <20071117185357.GC8206@c2.user-mode-linux.org>
In-Reply-To: <20071117185357.GC8206@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711181417.50745.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2007 12:53:57 Jeff Dike wrote:
> On Fri, Nov 16, 2007 at 04:00:22PM -0600, Rob Landley wrote:
> > I wasn't cc'd, and missed it.  I'd like to test this, do you have a
> > link?  (Or a bit more specificity than "a few weeks ago"?)
>
> Here are the three patches:
>
> 	http://marc.info/?l=linux-arch&m=119342916329510&w=2

Doesn't contain a patch.

> 	http://marc.info/?l=linux-kernel&m=119342916529516&w=2

Doesn't apply to vanilla 2.6.23, it can't find two files and a couple other 
hunks failed.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
