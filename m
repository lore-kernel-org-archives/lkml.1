Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXBFMqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXBFMqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXBFMqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:46:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49514 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbXBFMqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:46:03 -0500
Subject: Re: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <ak@muc.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20070206122514.GA47229@muc.de>
References: <200702060352.l163q87K000713@zach-dev.vmware.com>
	 <1170736029.29293.31.camel@localhost.localdomain>
	 <45C809F9.2090905@vmware.com>
	 <1170738676.29293.35.camel@localhost.localdomain>
	 <1170752856.7324.5.camel@laptopd505.fenrus.org>
	 <20070206122514.GA47229@muc.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 06 Feb 2007 13:45:52 +0100
Message-Id: <1170765952.7324.15.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 13:25 +0100, Andi Kleen wrote:
> > hmm stolen time could even be useful without virtualization; to a large
> > degree, if cpufreq reduces the speed of your cpu you have "stolen
> > cycles" that way... I wonder if this concept can be used for that as
> > well...

> 
> I don't see the point, frankly.

I mean for showing the sysadmin that his system has spare capacity left.

right now top shows 50% in use (at say 600Mhz) while the 2.8Ghz
processor obviously isn't even nearly half loaded.


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

