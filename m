Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYFFSEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYFFSEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 14:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYFFSD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 14:03:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbYFFSDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:03:55 -0400
Date: Fri, 6 Jun 2008 11:03:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: chris2553@googlemail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Message-Id: <20080606110345.581fdc77.akpm@linux-foundation.org>
In-Reply-To: <1212765742.16182.8.camel@localhost.localdomain>
References: <200806010415.05290.chris2553@googlemail.com>
	<20080605221709.f248eb90.akpm@linux-foundation.org>
	<200806060607.29460.chris2553@googlemail.com>
	<20080605232145.cdae753f.akpm@linux-foundation.org>
	<20080605232538.fb85021e.akpm@linux-foundation.org>
	<1212765742.16182.8.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 10:22:22 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-06-05 at 23:25 -0700, Andrew Morton wrote:
> > On Thu, 5 Jun 2008 23:21:45 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > <watches wodim wibble for five minutes then report "CD/DVD-Recorder
> > > not ready."  Pretends not to have noticed.>
> > 
> > It goes much better when the CD is inserted upside up.
> 
> So I can close this regression if I send you a pack of CD ring labels
> with "other way up" on them for you to affix to the underside of your
> CDs ... ?
> 

Would prefer double-sided CDs.

Is this 20-second-delay thing known-about/expected/etc?
