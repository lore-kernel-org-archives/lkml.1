Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0BKRoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:44:21 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36543 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab0BKRoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:44:20 -0500
Date: Thu, 11 Feb 2010 17:44:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] e1000e: Only disable ASPM on 82573L devices
Message-ID: <20100211174406.GB32319@srcf.ucam.org>
References: <1265905767-3884-1-git-send-email-mjg@redhat.com> <alpine.WNT.2.00.1002110916130.6892@jbrandeb-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.WNT.2.00.1002110916130.6892@jbrandeb-desk1.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:17:12AM -0800, Brandeburg, Jesse wrote:
> 
> 
> On Thu, 11 Feb 2010, Matthew Garrett wrote:
> 
> > The 82537 errata and comment in e1000e_disable_l1aspm both agree that
> > only 82537L devices are affected. Limit the L1 disable to them.
> 
> Hi Matthew, its a nitpick, but can you please change the part number to 
> the correct one?  it should be s/82537/82573

Whoops! Sorry, I'll do that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
