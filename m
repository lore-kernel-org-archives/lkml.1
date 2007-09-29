Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbXI2AC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbXI2AC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbXI2ACv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:02:51 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:45313 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbXI2ACu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:02:50 -0400
Date: Fri, 28 Sep 2007 20:02:47 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [COMPAT] Add compat_merge64 helper
Message-ID: <20070929000247.GE25346@fattire.cabal.ca>
References: <1191018832-18069-1-git-send-email-kyle@mcmartin.ca> <200709290138.24562.arnd@arndb.de> <20070929000131.GD25346@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929000131.GD25346@fattire.cabal.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 08:01:31PM -0400, Kyle McMartin wrote:
> I checked powerpc, sparc, and mips, which are (besides parisc) the only
> 64-bit with 32-bit userspace big endian architectures that I could think
> of offhand. A quick grep shows sh64 too... Paul?
> 

Ah, no CONFIG_COMPAT on sh64 anyways.
