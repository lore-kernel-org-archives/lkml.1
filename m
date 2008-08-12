Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYHLNF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYHLNF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYHLNFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:05:18 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:56837 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752573AbYHLNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:05:17 -0400
Date: Tue, 12 Aug 2008 14:05:08 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: MMC: s3cmci: wirte get_cd host ops
Message-ID: <20080812130508.GK8301@fluff.org.uk>
References: <20080811224200.522806334@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811224200.522806334@fluff.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 11:42:00PM +0100, Ben Dooks wrote:
> Attach the routine to get_cd to allow the MMC core to find out whether
> there is a card present or not without the tedious process of trying to
> send commands to the card or not.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

better spelled version posted.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
