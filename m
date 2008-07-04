Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYGDBQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYGDBQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYGDBQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:16:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYGDBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:16:13 -0400
Date: Thu, 3 Jul 2008 18:09:26 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nathan Lynch <ntl@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Removing sysdevs?
Message-ID: <20080704010926.GD20597@kroah.com>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com> <486B9B3A.4060709@firstfloor.org> <20080702185145.GB20938@kroah.com> <200807022341.44965.rjw@sisk.pl> <20080702214853.GA10451@kroah.com> <486BF9AC.6070704@firstfloor.org> <20080702221517.GA17929@kroah.com> <486CA18A.2040604@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486CA18A.2040604@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 11:53:14AM +0200, Andi Kleen wrote:
> 
> > The patches look fine, do you want me to take them through my tree, or
> > do you want to have them go through somewhere else as you have some
> > dependancies on them?
> 
> Through your tree is fine. Thanks.
> 
> Perhaps drop the x86 dynamic bank patch, it would actually conflict
> with one patch currently in the x86 tree and doesn't really
> belong into your tree.

Dropped, I only applied the other 3.

thanks,

greg k-h
