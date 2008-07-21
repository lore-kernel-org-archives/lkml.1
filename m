Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYGUVhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYGUVhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYGUVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:37:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52338 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYGUVhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:37:45 -0400
Date: Mon, 21 Jul 2008 22:37:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ben Collins <bcollins@swissdisk.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Restore VT fonts on switch
Message-ID: <20080721213735.GA11648@srcf.ucam.org>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org> <20080721134327.3ffab96f@infradead.org> <1216673584.7585.189.camel@cunning> <20080721221204.1f3be45d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721221204.1f3be45d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 10:12:04PM +0100, Alan Cox wrote:
> > > do you have a list of which ones don't ?
> > 
> > I don't, but perhaps Matthew does.
> 
> Perhaps Matthew would care to file X bugs against those that get it wrong
> then.

It's hardly limited to X. Fonts are set through the kernel - why 
shouldn't it be the kernel's responsibility to ensure that they're 
restored?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
