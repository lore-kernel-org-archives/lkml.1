Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbZJZUlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbZJZUlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZJZUlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:41:45 -0400
Received: from verein.lst.de ([213.95.11.210]:35102 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbZJZUlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:41:44 -0400
Date: Mon, 26 Oct 2009 21:41:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>,
       Thomas Neumann <tneumann@users.sourceforge.net>
Subject: Re: [Bug #14387] deadlock with fallocate
Message-ID: <20091026204120.GA4673@lst.de>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.FQG.are5KB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dRYo8ss7vL.A.FQG.are5KB@chimera>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this actually is a regression.

