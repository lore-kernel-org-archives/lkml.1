Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYJ2DoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYJ2DoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 23:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYJ2Dnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 23:43:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:43581 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJ2Dnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 23:43:52 -0400
Date: Tue, 28 Oct 2008 20:44:16 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: annotate return value of pci_ioremap_bar with
 __iomem
Message-ID: <20081028204416.63b552a0@linux.intel.com>
In-Reply-To: <1225244477.11483.69.camel@brick>
References: <1225244477.11483.69.camel@brick>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 18:41:17 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Arjan, when you added this helper I think you omitted the iomem
> annotation.

fair enough

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
