Return-Path: <linux-kernel-owner+w=401wt.eu-S933276AbYBGAlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbYBGAlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933683AbYBGAS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:18:28 -0500
Received: from ns2.suse.de ([195.135.220.15]:35238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760942AbYBGAS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:18:26 -0500
Date: Wed, 6 Feb 2008 16:16:21 -0800
From: Greg KH <gregkh@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: create /sys/firmware/acpi/interrupts/ (v2)
Message-ID: <20080207001621.GB16728@suse.de>
References: <200802050230.10873.lenb@kernel.org> <20080206024349.GA10883@suse.de> <200802060133.25863.lenb@kernel.org> <200802060140.27116.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802060140.27116.lenb@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 01:40:26AM -0500, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> See Documentation/ABI/testing/sysfs-firmware-acpi
> 
> Inspired-by: Luming Yu <luming.yu@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>

Looks good to me, nice job.  And thanks for the documentation file.

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
