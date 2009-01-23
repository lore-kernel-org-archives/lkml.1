Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZAWAEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZAWAEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZAWADz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:03:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:56789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbZAWADz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:03:55 -0500
Date: Thu, 22 Jan 2009 16:02:29 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       yogeshwar sonawane <yogyas@gmail.com>, linux-pci@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] docs: move DMA-mapping.txt to Documentation/PCI/
Message-ID: <20090123000229.GA25577@suse.de>
References: <b681c62b0901220326h2fce7dc6x6e524567c8613736@mail.gmail.com> <20090122190216.GC11246@colo.lackof.org> <200901221120.16393.jbarnes@virtuousgeek.org> <49790424.6060400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49790424.6060400@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 03:41:24PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Move DMA-mapping.txt to Documentation/PCI/.
> 
> DMA-mapping.txt was supposed to be moved from Documentation/ to
> Documentation/PCI/.  The 00-INDEX files in those two directories
> were updated, along with a few other text files, but the file
> itself somehow escaped being moved, so move it and update more
> text files and source files with its new location.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc:	Greg Kroah-Hartman <gregkh@suse.de> # for staging/

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

