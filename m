Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbZFBC2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbZFBC2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 22:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZFBC2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 22:28:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbZFBC2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 22:28:43 -0400
Date: Mon, 1 Jun 2009 19:28:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Marc Zyngier <maz@wild-wind.fr.eu.org>, linux-kernel@vger.kernel.org,
       Andries Brouwer <Andries.Brouwer@cwi.nl>
Subject: Re: [PATCH] eisa.ids: Add Network Peripherals FDDI boards
Message-Id: <20090601192823.68befe31.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0905310041200.15490@ftp.linux-mips.org>
References: <alpine.LFD.1.10.0905310041200.15490@ftp.linux-mips.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009 00:54:26 +0100 (BST) "Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  Add EISA IDs for Network Peripherals FDDI boards.  Descriptions taken 
> from the respective EISA configuration files.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  It's unlikely we'll ever support these cards, the problem being the lack 
> of documentation.  Assuming the policy for the EISA ID database is the 
> same as for PCI I'm sending these entries for the sake of completeness.
> 
>  Please apply.
> 
>   Maciej
> 
> patch-mips-2.6.27-rc8-20081004-npi-eisa-0
> Index: linux-mips-2.6.27-rc8-20081004-dolch/drivers/eisa/eisa.ids
> ===================================================================
> --- linux-mips-2.6.27-rc8-20081004-dolch.orig/drivers/eisa/eisa.ids
> +++ linux-mips-2.6.27-rc8-20081004-dolch/drivers/eisa/eisa.ids

Gee.  Nobody has altered that file in six years.  Then again, few new
EISA cards have been designed in that time...
