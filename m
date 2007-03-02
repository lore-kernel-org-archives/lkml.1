Return-Path: <linux-kernel-owner+w=401wt.eu-S1422746AbXCBCCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422746AbXCBCCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422745AbXCBCCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:02:49 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:33023 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422744AbXCBCCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:02:48 -0500
Date: Fri, 2 Mar 2007 11:00:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC 2.6.20 1/2] fbdev, mm: Deferred IO support
Message-ID: <20070302020008.GA6822@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jaya Kumar <jayakumar.lkml@gmail.com>,
	linux-fbdev-devel@lists.sourceforge.net, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070225051312.17454.80741.sendpatchset@localhost> <20070301140131.GA6603@linux-sh.org> <45a44e480703011602j698f67dev469b49d6b527f502@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45a44e480703011602j698f67dev469b49d6b527f502@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 07:02:34PM -0500, Jaya Kumar wrote:
> On 3/1/07, Paul Mundt <lethal@linux-sh.org> wrote:
> >Any updates on this? If there are no other concerns, it would be nice to
> >at least get this in to -mm for testing if nothing else.
> 
> I think Andrew merged it into -mm.
> 
Ok, I didn't see it go in, sorry for the noise in that case.

> >Jaya, can you roll the fsync() patch in to your defio patch? There's not
> >much point in keeping them separate.
> >
> 
> I forgot to add that. Sorry about that. Should I resubmit with it or
> would you prefer to post it?

I'll repost it separately.
