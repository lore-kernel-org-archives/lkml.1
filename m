Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYGUVOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYGUVOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYGUVOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:14:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbYGUVOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:14:06 -0400
Date: Mon, 21 Jul 2008 14:13:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH 1/8] slub: Add defrag_ratio field and sysfs support.
Message-Id: <20080721141319.da871b67.akpm@linux-foundation.org>
In-Reply-To: <4884B68A.7070000@linux-foundation.org>
References: <Pine.LNX.4.64.0807191529450.13345@sbz-30.cs.Helsinki.FI>
	<20080719105239.4a89f64c.akpm@linux-foundation.org>
	<84144f020807200338s55074230he16cc3dda3b012e6@mail.gmail.com>
	<4884B68A.7070000@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 11:17:14 -0500
Christoph Lameter <cl@linux-foundation.org> wrote:

> Pekka Enberg wrote:
> > Hi Andrew,
> >
> > On Sat, Jul 19, 2008 at 8:52 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> >   
> >> Were you planning on sending out the patches to wire all this up
> >> to the notorious caches?
> >>     
> >
> > No, I wasn't because don't have those patches in my tree (and I
> > probably don't want them either). Christoph?
> >   
> I have those diffed against linux-next from a week ago or so and 
> rc8-mm1. Want me to post them?

Yes please.

> Would be good to have a tree to submit 
> against. rc8-mm1?

I guess so.
