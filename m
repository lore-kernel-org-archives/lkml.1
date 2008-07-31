Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYGaU6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYGaU6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYGaU6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:58:06 -0400
Received: from mail.queued.net ([207.210.101.209]:4134 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbYGaU6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:58:05 -0400
Date: Thu, 31 Jul 2008 16:57:56 -0400
From: Andres Salomon <dilinger@queued.net>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>,
       linux-geode@bombadil.infradead.org, linux-kernel@vger.kernel.org
Subject: pci resource conflicts
Message-ID: <20080731165756.4f5fc5a0@fred>
In-Reply-To: <20080731143635.GA12585@cosmic.amd.com>
References: <48916864.901@LiPPERTEmbedded.de>
	<20080731143635.GA12585@cosmic.amd.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 08:36:35 -0600
Jordan Crouse <jordan.crouse@amd.com> wrote:

> On 31/07/08 09:23 +0200, Jens Rottmann wrote:
[...]
> > Now about the baseaddress issue:
> > 
> > 
> > The problem is that Linux upon PCI scan detects a resource conflict
> > (which in fact is none, but Linux cannot know that) and moves the
> > resources (MFGPT IO space among them) to some other place.
> > 

Can you please provide more info on this?  Specifically, dmesg output
about which resources conflict would be helpful..
