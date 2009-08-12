Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZHLHby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZHLHby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 03:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZHLHbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 03:31:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42908 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbZHLHbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 03:31:53 -0400
Date: Wed, 12 Aug 2009 09:31:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Dillow <dave@thedillows.org>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
	/dev
Message-ID: <20090812073152.GB28848@basil.fritz.box>
References: <20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com> <87ljlxhrnr.fsf@basil.nowhere.org> <1249575658.19886.8.camel@lap75545.ornl.gov> <20090806183147.GA28409@suse.de> <1249772876.22248.34.camel@obelisk.thedillows.org> <20090810153943.GB7652@kroah.com> <1250001374.22248.65.camel@obelisk.thedillows.org> <20090811145523.GD14368@basil.fritz.box> <1250036727.26788.7.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250036727.26788.7.camel@obelisk.thedillows.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So use Eric/Arjan's program that does it in 60ms -- you get a
> dynamic /dev, no initrd, fast boot, and no kernel changes required.

That would likely need initrd at least on the distro I use which uses
device files very early.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
