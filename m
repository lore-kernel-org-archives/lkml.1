Return-Path: <linux-kernel-owner+w=401wt.eu-S932747AbYBHSwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbYBHSwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759702AbYBHSwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:52:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56076 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbYBHSwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:52:22 -0500
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM
	architecture
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080208184651.GA30729@uranus.ravnborg.org>
References: <20080207133805.13f092ff@dilbert.local>
	 <20080207125824.GB7111@infradead.org>
	 <20080207130117.GA18750@uranus.ravnborg.org>
	 <200802071609.36960.openembedded@haerwu.biz>
	 <20080207160557.GB28435@flint.arm.linux.org.uk>
	 <20080207202329.GA21949@uranus.ravnborg.org>
	 <1202461453.5469.217.camel@pmac.infradead.org>
	 <1202468309.5469.248.camel@pmac.infradead.org>
	 <20080208184651.GA30729@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 18:52:01 +0000
Message-Id: <1202496722.5469.339.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 19:46 +0100, Sam Ravnborg wrote:
> Here we do not need to have the "if ..."
> and can source drivers/mtd/Kconfig unconditional for arm?

Yes.

-- 
dwmw2

