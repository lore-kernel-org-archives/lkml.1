Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbZFPQoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbZFPQoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZFPQnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:43:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60679 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZFPQnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:43:52 -0400
Date: Tue, 16 Jun 2009 17:43:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, greg@kroah.com, yan.i.li@intel.com
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090616164351.GA14353@srcf.ucam.org>
References: <20090615141613.GA7876@sage.bj.intel.com> <20090615143446.GB19451@srcf.ucam.org> <20090615144748.GA25734@thyme.bj.intel.com> <20090616154200.GA12715@srcf.ucam.org> <20090616173618.353901ee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616173618.353901ee@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 05:36:18PM +0100, Alan Cox wrote:
> > So? If the alternative is machines that don't work until they're added 
> > to a blacklist, then the correct thing to do is to do it 
> > unconditionally.
> 
> I would disagree: that breaks a whole pile of other machines

I was under the impression that this was the reset path that Windows 
followed. If not then that suggests that we're fixing it wrong in the 
first place?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
