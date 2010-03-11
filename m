Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0CKSgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:36:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:43026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab0CKSbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:31:42 -0500
Date: Thu, 11 Mar 2010 10:28:52 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: monstr@monstr.eu, benh@kernel.crashing.org, akpm@linux-foundation.org,
       davem@davemloft.net, sfr@canb.auug.org.au, jgarzik@pobox.com,
       ben-linux@fluff.org, dwmw2@infradead.org, jeremy.kerr@canonical.com,
       James.Bottomley@suse.de, broonie@opensource.wolfsonmicro.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, netdev@vger.kernel.org,
       linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 05/27] drivers/usb/of: don't use deprecated field in
	of_platform_driver
Message-ID: <20100311182852.GB1950@suse.de>
References: <20100311181604.13103.30088.stgit@angua> <20100311182215.13103.45160.stgit@angua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311182215.13103.45160.stgit@angua>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 11:22:15AM -0700, Grant Likely wrote:
> .name, .match_table and .owner are duplicated in both of_platform_driver
> and device_driver, so the of_platform_driver copies will be removed soon.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
