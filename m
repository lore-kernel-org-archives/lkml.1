Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbXJ2PL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbXJ2PL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXJ2PLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:11:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55666 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbXJ2PLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:11:20 -0400
Date: Mon, 29 Oct 2007 16:11:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tom Southerland <toms@wonderland.us.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/net/sunhme.c patch
In-Reply-To: <4725F416.2030100@wonderland.us.com>
Message-ID: <Pine.LNX.4.64.0710291606260.26070@fbirervta.pbzchgretzou.qr>
References: <4725F416.2030100@wonderland.us.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 29 2007 08:54, Tom Southerland wrote:
>
> This patch provides a unique mac address for all interfaces
> for the Sun QFE card (non-sparc).  It takes the base mac from
> the first interface and increments the mac address for the
> other interfaces.

Where is the difference to a SPARC QFE? PCI is PCI after all, is not it?
