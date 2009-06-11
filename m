Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbZFKWSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbZFKWSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZFKWSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:18:24 -0400
Received: from outbound-mail-27.bluehost.com ([69.89.17.193]:60841 "HELO
	outbound-mail-27.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753324AbZFKWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:18:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fneqpE2XYIq3/h6+iIEzI4KOVwo79gaDODW7NzjcBfaCxzTkoJ5AVuhZFINJ/UgcgXOwFuXJCpV+Jxll+JU+vmiFUeJWOL2AfnxU/n9VitbFPoYAVxiPJxlENMcL1SS5;
Date: Thu, 11 Jun 2009 15:17:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alex Chiang <achiang@hp.com>, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 08/11] PCI Hotplug: acpiphp: convert to
 acpi_get_pci_dev
Message-ID: <20090611151743.6586cbb3@jbarnes-g45>
In-Reply-To: <20090611144845.76e7dc1d@jbarnes-g45>
References: <20090604054504.18802.21690.stgit@bob.kio>
	<20090604055857.18802.34388.stgit@bob.kio>
	<20090611144845.76e7dc1d@jbarnes-g45>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 14:48:45 -0700
Jesse Barnes <jesse.barnes@intel.com> wrote:

> On Wed, 03 Jun 2009 23:58:57 -0600
> Alex Chiang <achiang@hp.com> wrote:
> 
> > Now that acpi_get_pci_dev is available, let's use it instead of
> > acpi_get_pci_id.
> > 
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> > ---
> > 
> 
> Applied to linux-next, thanks.

Oops, since this one depends on others in the series it's probably best
if they just go in through Len's tree.  This one has my 
  Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
too.

-- 
Jesse Barnes, Intel Open Source Technology Center
