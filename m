Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbXKNPAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbXKNPAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXKNPA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:00:27 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48522 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbXKNPA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:00:27 -0500
Date: Wed, 14 Nov 2007 08:00:25 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, Alex Chiang <achiang@hp.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, richard.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114150025.GU17785@parisc-linux.org>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <p73sl39y6qb.fsf@bingen.suse.de> <20071114141751.GS17785@parisc-linux.org> <20071114143533.GF17145@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114143533.GF17145@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 03:35:33PM +0100, Andi Kleen wrote:
> It becomes much more when someone does a find /sys. dentries are 
> expensive. They eventually can get pruned again, but it's still
> costly to do that.

Again, if this is a big concern for you, there are better places to look
at for savings.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
