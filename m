Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbXGNKud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbXGNKud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 06:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbXGNKuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 06:50:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57563 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbXGNKuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 06:50:13 -0400
Date: Sat, 14 Jul 2007 11:50:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] Text Edit Lock
Message-ID: <20070714105010.GC7358@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070714012133.612727310@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714012133.612727310@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 09:21:33PM -0400, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> After refactoring of architecture independant code (mutex to protect text
> edition) vs architecture dependant code (marking/unmarking pages RW) and
> thorough testing, here is the new version of the text edit lock.

Do you have a tarball of your quilt series for markers and all the patches
leading to them?  Trying to hand apply half a dozend patch series is not
too nice :)

