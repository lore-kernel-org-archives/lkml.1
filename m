Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbYKQOpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbYKQOpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 09:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYKQOo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 09:44:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYKQOoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 09:44:55 -0500
Date: Mon, 17 Nov 2008 09:44:53 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <dgc@sgi.com>, Tiago Maluta <maluta_tiago@yahoo.com.br>
Subject: Re: [Bug #11805] mounting XFS produces a segfault
Message-ID: <20081117144452.GA5111@infradead.org>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.h4.kIHIJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NjF0-fuClJC.A.h4.kIHIJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 06:40:58PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).

The patch for this is both in mainline and -stable

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11805
> Subject		: mounting XFS produces a segfault
> Submitter	: Tiago Maluta <maluta_tiago@yahoo.com.br>
> Date		: 2008-10-21 18:00 (27 days old)
> Handled-By	: Dave Chinner <dgc@sgi.com>

And that email address for Dave is severly outdated.

