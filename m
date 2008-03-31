Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYCaMLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYCaMLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYCaMK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:10:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38971 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYCaMK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:10:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Date: Mon, 31 Mar 2008 14:10:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803272353.51901.rjw@sisk.pl> <86802c440803272031o2d3c1d3aw4f03e60883a8716e@mail.gmail.com> <47F0B98E.6090107@linux.vnet.ibm.com>
In-Reply-To: <47F0B98E.6090107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803311410.41483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 31 of March 2008, Kamalesh Babulal wrote:
> Yinghai Lu wrote:
> > On Thu, Mar 27, 2008 at 7:30 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >>  On Thu, 27 Mar 2008, Rafael J. Wysocki wrote:
> >>  >
> > ...
> >>  > Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=9962
> >>  > Subject               : mount: could not find filesystem
> >>  > Submitter     : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> >>  > Date          : 2008-02-12 14:34 (45 days old)
> >>  > References    : http://lkml.org/lkml/2008/2/12/91
> >>  > Handled-By    : Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>  >                 Yinghai Lu <yhlu.kernel@gmail.com>
> >>
> >>  Needs more info. The original oops that opened it is fixed, but..
> >>
> > Kamalesh,
> > can you check that?
> > 
> > YH
> Hi,
> 
> I have tested the 2.6.25-rc7 kernel and the kernel boots up without the panic.

Thanks for the update, I closed the bug.

Thanks,
Rafael
