Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZF0KwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZF0KwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 06:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZF0Kv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 06:51:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60701 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZF0Kv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 06:51:57 -0400
Date: Sat, 27 Jun 2009 11:51:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20090627105150.GA4780@sirena.org.uk>
References: <1246072682.10360.424.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246072682.10360.424.camel@brutus>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3] PCAP regulator driver (for 2.6.32)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 12:18:02AM -0300, Daniel Ribeiro wrote:
> Add (partial) support for the voltage regulators on the PCAP2 PMIC.
> 
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Looks good.

> Mark, can you please assert that this only gets merged after Samuel has
> a chance to merge the set_bits patch? Thanks!

It's Liam who manages the regulator tree, though given the set_bits()
patch perhaps this one might end up getting merged via the MFD tree (or
both via the regulator tree).
