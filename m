Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYAHSPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYAHSPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYAHSPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:15:07 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46364 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750902AbYAHSPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:15:06 -0500
From: akepner@sgi.com
Date: Tue, 8 Jan 2008 10:13:36 -0800
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_* routines
Message-ID: <20080108181336.GZ23661@sgi.com>
References: <20080108023222.GP23661@sgi.com> <1199809628.3534.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199809628.3534.34.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 10:27:08AM -0600, James Bottomley wrote:

> .... All of the attributes I can see adding are
> bus specific (even to the extent that PCIe ones wouldn't apply to PCI
> for instance)....
>

The attribute I want to pass isn't bus-specific, but architecture-
specific.

-- 
Arthur

