Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZK3XOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZK3XOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZK3XOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:14:32 -0500
Received: from xenotime.net ([72.52.64.118]:54808 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753836AbZK3XOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:14:30 -0500
Date: Mon, 30 Nov 2009 15:14:35 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: Fix a stale reference in
 Documentation/DMA-API.txt
Message-Id: <20091130151435.a5a33a53.rdunlap@xenotime.net>
In-Reply-To: <200911291351.15015.bart.vanassche@gmail.com>
References: <200911291351.15015.bart.vanassche@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Nov 2009 13:51:14 +0100 Bart Van Assche wrote:

> Fixes a stale reference in Documentation/DMA-API.txt.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> 
> diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
> index 5aceb88..51b4ca1 100644
> --- a/Documentation/DMA-API.txt
> +++ b/Documentation/DMA-API.txt
> @@ -5,7 +5,7 @@
>  
>  This document describes the DMA API.  For a more gentle introduction
>  phrased in terms of the pci_ equivalents (and actual examples) see
> -Documentation/PCI/PCI-DMA-mapping.txt.
> +Documentation/DMA-mapping.txt.

The text file should be moved/renamed to Documentation/PCI/PCI-DMA-mapping.txt.
I have another recent patch that does half of that.
I'll get it fixed up.

Thanks.

>  This API is split into two pieces.  Part I describes the API and the
>  corresponding pci_ API.  Part II describes the extensions to the API


---
~Randy
