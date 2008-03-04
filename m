Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbYCDXrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbYCDXrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761679AbYCDXqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:46:49 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26343 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011AbYCDXqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:46:47 -0500
Date: Tue, 4 Mar 2008 16:46:46 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080304234646.GH3694@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
	Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
	warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002938.GE21420@ldl.fc.hp.com> <20080301052542.GD19353@suse.de> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <20080304225830.GC3694@ldl.fc.hp.com> <20080304231525.GA25125@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304231525.GA25125@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, all,

* Greg KH <gregkh@suse.de>:
> On Tue, Mar 04, 2008 at 03:58:30PM -0700, Alex Chiang wrote:
> 
> > Again, I'm thinking more exposure in linux-next might be a
> > reasonable way for us to figure out how bad (or good) the
> > situation might really be out there.
> 
> Ok, care to resend them with the requested updates?

Thanks, I need to review my patch that touches SGI after thinking
about Prarit's comment some more.

Look for v8 of series to come out later (and please ignore that
stray patch I sent out a few minutes ago with subject [PATCH 3/4,
v8]).

Thanks.

/ac

