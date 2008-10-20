Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbYJTGNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbYJTGNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 02:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYJTGNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 02:13:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55582 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYJTGNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 02:13:04 -0400
Date: Mon, 20 Oct 2008 08:20:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Remove rogue default ms for THRUSTMASTER/ZEROPLUS in drivers/hid/Kconfig
Message-ID: <20081020062015.GD12825@one.firstfloor.org>
References: <1224398310-10676-1-git-send-email-andi@firstfloor.org> <alpine.LNX.1.10.0810192035380.27479@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810192035380.27479@jikos.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 08:36:23PM +0200, Jiri Kosina wrote:
> On Sun, 19 Oct 2008, Andi Kleen wrote:
> 
> > No reason at all to make these obscure drivers default m
> 
> Agreed and applied, thanks.

Can you please merge them still for 2.6.28? It would be sad if lots 
of .configs got these.

-Andi
-- 
ak@linux.intel.com
