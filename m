Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbXJKVtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbXJKVtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbXJKVtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:49:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42516 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbXJKVtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:49:02 -0400
Date: Thu, 11 Oct 2007 14:38:40 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] PCI: Add 'nodomains' boot option, and
	pci_domains_supported global
Message-ID: <20071011213840.GB32752@kroah.com>
References: <20071011205727.GA29222@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011205727.GA29222@havoc.gtf.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 04:57:27PM -0400, Jeff Garzik wrote:
> +enum { pci_domains_supported = 0; };

I don't think you compiled this option :)

I've fixed the compiler error in my version.

thanks,

greg k-h
