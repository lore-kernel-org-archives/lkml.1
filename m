Return-Path: <linux-kernel-owner+w=401wt.eu-S935749AbZLHBe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935749AbZLHBe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935177AbZLHBeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:34:25 -0500
Received: from trinity.fluff.org ([89.16.178.74]:49404 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935163AbZLHBeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:34:25 -0500
Date: Tue, 8 Dec 2009 01:34:30 +0000
From: Ben Dooks <ben@trinity.fluff.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the samsung tree
Message-ID: <20091208013430.GH23152@trinity.fluff.org>
References: <20091208111722.2e8d9527.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208111722.2e8d9527.sfr@canb.auug.org.au>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:17:22AM +1100, Stephen Rothwell wrote:
> Hi Ben,
> 
> In today's linux-next merge of the samsung tree I noticed that the file
> arch/arm/plat-s3c/dev-hsmmc2.c actually has some merge conflict artifacts
> in it.
> 
> I fixed them up (just by using the version from the arm tree) but it
> would be good if this could be fixed in your tree as well (I notice that
> Russell has already merged a (presumable) correct version of these files).

I belive so, I've updated next-samsung from my for-rmk tree and added the
rebased new trees to it which should fix it.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

