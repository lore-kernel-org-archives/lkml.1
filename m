Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbXJ2KOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbXJ2KOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXJ2KOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:14:25 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46667 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbXJ2KOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:14:24 -0400
Date: Mon, 29 Oct 2007 11:14:10 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Dirk Hohndel <hohndel@linux.intel.com>
cc: Jeff Garzik <jeff@garzik.org>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from
 input_register_device
In-Reply-To: <20071029084917.GA12968@bigserver.hohndel.org>
Message-ID: <Pine.LNX.4.64.0710291113450.18815@twin.jikos.cz>
References: <20071029084917.GA12968@bigserver.hohndel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Dirk Hohndel wrote:

> [INPUT] hidinput_connect incorrectly ignored return value from 
> input_register_device
> Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>

Will apply, thanks a lot.

-- 
Jiri Kosina
