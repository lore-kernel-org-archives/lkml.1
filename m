Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbXHFWbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbXHFWbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760689AbXHFWbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:31:15 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:54391 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbXHFWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:31:14 -0400
Date: Mon, 6 Aug 2007 18:31:10 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Few interrupts with NO_HZ
Message-ID: <20070806223110.GA21368@fattire.cabal.ca>
References: <Pine.LNX.4.64.0708061247150.13469@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708061247150.13469@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 12:52:36PM +0200, Jan Engelhardt wrote:
>            CPU0
>   0:        282   IO-APIC-edge      timer

Look at the LOC line.
