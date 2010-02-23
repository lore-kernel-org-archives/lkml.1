Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0BWAYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 19:24:14 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:55537 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751422Ab0BWAYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 19:24:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jT54TTEgoCsc6SEYqsNForTK0skxOcKy0u9CT3KskMRFKqPvHVMV+PFkd+WXdh+61/+sWRgm0GzVffbsKxbYBN1Vs0e6t3mQ6GOh0DbjJ8JSUk5jYUKpb7JgeVwfNOaG;
Date: Mon, 22 Feb 2010 16:21:42 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 1/8] PCI PM: Add function for checking PME status of
 devices
Message-ID: <20100222162142.06095230@jbarnes-piketon>
In-Reply-To: <201002172336.58766.rjw@sisk.pl>
References: <201002172335.47703.rjw@sisk.pl>
	<201002172336.58766.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 23:36:58 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add function pci_check_pme_status() that will check the PME status
> bit of given device and clear it along with the PME enable bit.  It
> will be necessary for PCI run-time power management.
> 
> Based on a patch from Shaohua Li <shaohua.li@intel.com>
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

Applied this series and dropped the old patches, thanks Rafael.

-- 
Jesse Barnes, Intel Open Source Technology Center
