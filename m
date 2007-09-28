Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbXI1RMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbXI1RMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXI1RMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:12:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45325 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbXI1RMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:12:30 -0400
Date: Fri, 28 Sep 2007 10:11:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Herrmann <aherrman@arcor.de>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
Message-ID: <20070928101123.4c5bb8a6@laptopd505.fenrus.org>
In-Reply-To: <200709281005.34001.nickpiggin@yahoo.com.au>
References: <20070918080537.GA14882@devil>
	<200709280740.40163.nickpiggin@yahoo.com.au>
	<alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org>
	<200709281005.34001.nickpiggin@yahoo.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:05:33 +1000
> Sure, that would probably be pretty trivial to implement too, and
> would solve most problems for kernel devs.
> 
> At a level up from that, I think ease of use could be improved with
> a package manager-type chained-selection/deselection feature in
> the config tools.
> 
only if you make it Aunt-Tilly friendly

/me runs like hell
