Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZFCDDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZFCDDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZFCDD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:03:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45567 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZFCDD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:03:27 -0400
Date: Wed, 3 Jun 2009 04:03:21 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: manual merge of the wireless tree with the acpi
	tree
Message-ID: <20090603030321.GB28009@srcf.ucam.org>
References: <20090603122046.6aa99d91.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603122046.6aa99d91.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 12:20:46PM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless tree got a conflict in
> drivers/platform/x86/Kconfig between commit
> eedd8dca3c0e6c1fcb5cba11321ea9d69917d85b ("eeepc-laptop: Register as a
> pci-hotplug device") from the acpi tree and commit
> c6d660ce29295d344fcdc3654274b4a0aad1a9c8 ("rfkill: rewrite") from the
> wireless tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Patch looks fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
