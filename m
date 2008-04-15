Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYDOSB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYDOSB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYDOSBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:01:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbYDOSBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:01:20 -0400
Date: Tue, 15 Apr 2008 10:59:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       borntraeger@de.ibm.com, peter.oberparleiter@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: Re: + s390-tty-prepare-for-put_char-to-return-success-fail.patch
 added to -mm tree
Message-Id: <20080415105954.2243e1e6.akpm@linux-foundation.org>
In-Reply-To: <20080415110745.GA11858@devserv.devel.redhat.com>
References: <200804150204.m3F24GdU005600@imap1.linux-foundation.org>
	<20080415072117.GA4177@osiris.boeblingen.de.ibm.com>
	<20080415111101.41b6e9e3@core>
	<20080415104507.GA18307@osiris.boeblingen.de.ibm.com>
	<20080415110745.GA11858@devserv.devel.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 07:07:45 -0400 Alan Cox <alan@redhat.com> wrote:

> On Tue, Apr 15, 2008 at 12:45:07PM +0200, Heiko Carstens wrote:
> > Ok, thanks for pointing this out! We are going to fix this as soon as your
> > patch is merged, so we can avoid further merge conflicts.
> > I assume your patch is for 2.6.26?
> 
> I would hope so - assuming no other bugs fall out of this.
> 

It might be a bit late to find out - I'll _try_ to squeeze a -mm out this
week, but I have an ill-timed trip next week and then we're into the merge
window.

So please do double-check that it's not all catastrophically buggy in some
way ;)

