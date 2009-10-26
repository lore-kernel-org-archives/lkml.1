Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZJZUoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZJZUoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZJZUo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:44:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60364 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbZJZUo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:44:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [Bug #14387] deadlock with fallocate
Date: Mon, 26 Oct 2009 21:46:12 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Neumann <tneumann@users.sourceforge.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.FQG.are5KB@chimera> <20091026204120.GA4673@lst.de>
In-Reply-To: <20091026204120.GA4673@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262146.12481.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Christoph Hellwig wrote:
> I don't think this actually is a regression.

OK, dropping from the list.
