Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZFCDFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZFCDFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZFCDFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:05:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45598 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZFCDFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:05:42 -0400
Date: Wed, 3 Jun 2009 04:05:41 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: manual merge of the wireless tree with the acpi
	tree
Message-ID: <20090603030541.GC28009@srcf.ucam.org>
References: <20090603122724.ddf679ba.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603122724.ddf679ba.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Easiest in this case might be to drop the toshiba-acpi patches from me 
from acpi-test for the moment - I'm still waiting for some testing 
feedback on them. I can rebase against the rfkill code as long as it 
lands early enough.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
