Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZBONoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZBONoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 08:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZBONnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 08:43:52 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56716 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbZBONnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 08:43:51 -0500
Date: Sun, 15 Feb 2009 13:43:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Nico Schottelius <nico-linux-20090213@schottelius.org>,
       eric.anholt@intel.com
Subject: Re: [Bug #12705] X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090215134347.GB21670@srcf.ucam.org>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.htD.Sr0lJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rjPbZ5GRJPO.A.htD.Sr0lJB@chimera>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 09:38:23PM +0100, Rafael J. Wysocki wrote:

> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).

I think Eric sent a test patch for this. Did that get pushed?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
