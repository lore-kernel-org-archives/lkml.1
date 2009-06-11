Return-Path: <linux-kernel-owner+w=401wt.eu-S1762274AbZFKECP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762274AbZFKECP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 00:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbZFKECB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 00:02:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759257AbZFKECA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 00:02:00 -0400
Date: Wed, 10 Jun 2009 20:49:55 -0700
From: Greg KH <gregkh@suse.de>
To: =?utf-8?B?VG9tw6HFoSBTesOpcGU=?= <szepe@pinerecords.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.28.x FIX] CONFIG_FILE_LOCKING should not depend on
	CONFIG_BLOCK
Message-ID: <20090611034954.GA21231@suse.de>
References: <20090611024019.GC25384@louise.pinerecords.com> <20090611024641.GA19767@suse.de> <20090611030759.GA25569@louise.pinerecords.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090611030759.GA25569@louise.pinerecords.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 05:07:59AM +0200, Tomáš Szépe wrote:
> > > Fix: CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK.
> > > Patch against 2.6.28.10.
> > > 
> > > inlined please find a trivial fix that makes it possible to run
> > > complete systems out of an initramfs on 2.6.28.10 again (this
> > > broke somewhere between 2.6.27 and 2.6.28).
> > 
> > 2.6.28 is no longer supported, sorry.
> > Is this an issue in 2.6.29 or 2.6.30?
> 
> Yes.  I also sent a patch (in a separate email) that applies
> on 2.6.29.x, 2.6.30.x, and current git master branch head.

Ah, ok, I see that now, sorry for getting ahead.

greg k-h
