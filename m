Return-Path: <linux-kernel-owner+w=401wt.eu-S1765605AbXHWSo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765605AbXHWSo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 14:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764534AbXHWSow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 14:44:52 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36712 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764440AbXHWSov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 14:44:51 -0400
Date: Thu, 23 Aug 2007 13:44:44 -0500
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh <greg@kroah.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] PCI AER: fix warnings when PCIEAER=n
Message-ID: <20070823184444.GD4282@austin.ibm.com>
References: <20070823103753.f048aa3a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823103753.f048aa3a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 10:37:53AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix warnings when CONFIG_PCIEAER=n:
> 
> drivers/pci/pcie/portdrv_pci.c:105: warning: statement with no effect
> drivers/pci/pcie/portdrv_pci.c:226: warning: statement with no effect
> drivers/scsi/arcmsr/arcmsr_hba.c:352: warning: statement with no effect
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Linas Vepstas <linas@austin.ibm.com>

--linas

