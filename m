Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbXFKQTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbXFKQTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXFKQTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:19:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58021 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752125AbXFKQTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:19:08 -0400
Date: Mon, 11 Jun 2007 09:19:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/slub.c:3689!
In-Reply-To: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
Message-ID: <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com>
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Haavard Skinnemoen wrote:

> While trying to get SLUB debugging to not break DMA on AVR32, I ran
> into this:

This is a known bug in 2.6.22-rc2/rc3. Which version are you running?
