Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZFKVtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZFKVtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZFKVtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:49:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:59457 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZFKVtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:49:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,204,1243839600"; 
   d="scan'208";a="698621535"
Date: Thu, 11 Jun 2009 14:48:45 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 08/11] PCI Hotplug: acpiphp: convert to
 acpi_get_pci_dev
Message-ID: <20090611144845.76e7dc1d@jbarnes-g45>
In-Reply-To: <20090604055857.18802.34388.stgit@bob.kio>
References: <20090604054504.18802.21690.stgit@bob.kio>
	<20090604055857.18802.34388.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jun 2009 23:58:57 -0600
Alex Chiang <achiang@hp.com> wrote:

> Now that acpi_get_pci_dev is available, let's use it instead of
> acpi_get_pci_id.
> 
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
