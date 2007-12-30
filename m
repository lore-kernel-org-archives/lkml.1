Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbXL3KSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbXL3KSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 05:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbXL3KS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 05:18:27 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:54656 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbXL3KS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 05:18:27 -0500
Date: Sun, 30 Dec 2007 13:18:39 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Anders Hammarquist <iko@cd.chalmers.se>
Cc: linux-kernel@vger.kernel.org, rth@twiddle.net
Subject: Re: [PATCH] include/asm-alpha/core_cia.h, kernel 2.6.23.12
Message-ID: <20071230101839.GA18200@jurassic.park.msu.ru>
References: <20071230062354.8A4FB38414@haddock.cd.chalmers.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230062354.8A4FB38414@haddock.cd.chalmers.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 07:23:53AM +0100, Anders Hammarquist wrote:
> Trying to compile 2.6.23.12 on alpha (a miata) resulted in this
> failure:
> 
> cc1: warnings being treated as errors
> include/asm/io_trivial.h: In function 'cia_readb':
> include/asm/io_trivial.h:75: warning: passing argument 1 of 'cia_ioread8' discards qualifiers from pointer target type

Fixed in 2.6.24-rc6.

Ivan.
