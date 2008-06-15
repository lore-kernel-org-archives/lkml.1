Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYFOS35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYFOS35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 14:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758942AbYFOS3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 14:29:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53799 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847AbYFOS3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 14:29:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for June 13
Date: Sun, 15 Jun 2008 20:31:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
In-Reply-To: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806152031.01959.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 of June 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080612:
> 
> New tree: kgdb
> Dropped trees (temporary): ldp (it is unfetchable - probably something to
> do with the new Staging tree)
> Restored trees: block
> 
> The x86 tree gained a conflict with Linus' tree.
> 
> The acpi tree gained a conflict with the pci tree.
> 
> The mtd tree gained a trivial conflict with the avr32 tree.
> 
> The rr tree lost its conflict with the net-current tree.
> 
> The block tree gained several conflict with various other trees.  It also
> required a build fix patch.
> 
> The firmware tree lost its build fix patch.
> 
> The patches for known build problems are no longer needed.

20080613 doesn't boot on my HP nx6325.  Bisecting ...

Thanks,
Rafael
