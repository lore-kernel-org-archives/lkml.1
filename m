Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYBLLvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYBLLvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYBLLvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:51:41 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:60337 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896AbYBLLvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:51:41 -0500
Date: Tue, 12 Feb 2008 11:51:36 +0000
From: Ben Dooks <ben@fluff.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, ben@fluff.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] sm501: Add uart support
Message-ID: <20080212115136.GA26519@fluff.org.uk>
References: <20080208095742.2041.46016.sendpatchset@clockwork.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208095742.2041.46016.sendpatchset@clockwork.opensource.se>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 06:57:42PM +0900, Magnus Damm wrote:
> This patch extends the sm501 mfd with 8250 uart support. We're currently
> doing this in the board specific r2d-1 code already, but it would be nice to
> do move things into the mfd since it's more chip specific than board specific.

Looks fine, will add to my set of SM501 changes to keep track of things
ready for the next kernel release window.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
