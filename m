Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbYDWITI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbYDWITI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYDWISw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:18:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYDWISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:18:50 -0400
Date: Wed, 23 Apr 2008 04:18:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: remove unused parameter of xfs_qm_dqpurge
Message-ID: <20080423081834.GA17977@infradead.org>
References: <20080419142329.GA5339@elte.hu> <200804220503.16888.vda.linux@googlemail.com> <200804220514.45191.vda.linux@googlemail.com> <200804221142.00914.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804221142.00914.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI: if you want to sumbit xfs patches it makes a lot of sense to send
them to the xfs list..

