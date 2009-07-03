Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZGCKLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZGCKLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZGCKLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:11:42 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:55527 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZGCKLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:11:41 -0400
Subject: Re: [PATCHv3] PCAP regulator driver (for 2.6.32)
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
In-Reply-To: <20090703093517.GA4176@sortiz.org>
References: <1246072682.10360.424.camel@brutus>
	 <20090627105150.GA4780@sirena.org.uk> <1246123618.3727.29.camel@brutus>
	 <20090703093517.GA4176@sortiz.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 11:11:41 +0100
Message-Id: <1246615901.4438.1107.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 11:35 +0200, Samuel Ortiz wrote:
> Hi Daniel,
> 
> On Sat, Jun 27, 2009 at 02:26:58PM -0300, Daniel Ribeiro wrote:

> > 
> > Ideally, Samuel would push the PCAP patches on -rc phase, so the
> > sub-drivers can all be merged through the respective subsystem trees on
> > the .32 merge window.
> If that's ok with Liam, I'll take the regulator patch. Most of the pcap
> patches are not rc material, so they will be merged along with the regulator
> driver with the next merge window.
> 
> Liam, if you're fine with this patch, could you please SOB it ? Thanks.

Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>

Thanks!

Liam


