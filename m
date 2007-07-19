Return-Path: <linux-kernel-owner+w=401wt.eu-S934389AbXGSAsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389AbXGSAsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbXGSAsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:48:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:47053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391AbXGSAsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:48:04 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH][ACPI] Fix acpi_ev_pci_config_region_setup() to avoid memory leak
Date: Wed, 18 Jul 2007 20:47:30 -0400
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robert.moore@intel.com, akpm@linux-foundation.org
References: <200707190048.03992.jesper.juhl@gmail.com>
In-Reply-To: <200707190048.03992.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707182047.30766.lenb@kernel.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007 18:48, Jesper Juhl wrote:
> drivers/acpi/events/evrgnini.c

applied (after changing to ACPI_FREE())

thanks,
-Len

