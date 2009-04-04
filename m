Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZDDQ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZDDQ32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZDDQ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:29:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:59100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbZDDQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:29:19 -0400
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: David Woodhouse <dwmw2@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: Kevin Cernekee <kpc.mtd@gmail.com>, dedekind@infradead.org,
       Linux MTD <linux-mtd@lists.infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200904040920.06981.david-b@pacbell.net>
References: <200903260042.42091.david-b@pacbell.net>
	 <a95a62fe0904031300i82bdf42h5bc854a002e0091e@mail.gmail.com>
	 <1238855797.4068.6.camel@macbook.infradead.org>
	 <200904040920.06981.david-b@pacbell.net>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 17:29:12 +0100
Message-Id: <1238862552.4068.42.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-04 at 09:20 -0700, David Brownell wrote:
> On Saturday 04 April 2009, David Woodhouse wrote:
> > think I'm going to add a WARN_ON(&mtd->dev.parent) into the core code.
> 
> I hope you mean WARN_ON(!mtd->dev.parent) ... :)

If I didn't, I'd probably change my mind fairly quickly... :)

-- 
dwmw2

