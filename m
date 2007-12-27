Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbXL0Xx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbXL0Xx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 18:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXL0Xxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 18:53:46 -0500
Received: from relay2.sgi.com ([192.48.171.30]:59607 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753367AbXL0Xxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 18:53:45 -0500
Date: Thu, 27 Dec 2007 15:53:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: SLUB sysfs support
In-Reply-To: <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0712271552420.1154@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com>
 <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org>
 <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
 <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com>
 <20071226221631.GD27894@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com>
 <20071227225947.GH27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007, Christoph Lameter wrote:

> > a) remove symlink when slab goes away
> 
> Ok. Need to think about how to code that.

How do I iterate over all symlinks in /sys/kernel/slab/*?

I remember trying to do it before and not being able to find a sysfs 
method for that.

