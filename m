Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbXBYTjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbXBYTjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXBYTjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:39:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39432 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbXBYTjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:39:51 -0500
Date: Sun, 25 Feb 2007 20:39:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Schwartz <davids@webmaster.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070225193907.GA1802@elf.ucw.cz>
References: <20070225104211.GB2045@elf.ucw.cz> <MDEHLPKNGKAHNMBLJOLKOEDMBNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEDMBNAC.davids@webmaster.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-02-25 03:33:38, David Schwartz wrote:
> 
> > But... how does situation change when Evil Linker does #include
> > <pop3/gpl_header_file_with_some_inline_functions.h> from his
> > binary-only part?
> 
> Right, but *why* is he doing that? The answer: It is the most practical way
> to write his driver.

Most practical way to get something Windows compatible is to pirate
Windows; I do not think that gives me permission to do so.

Similary, there are many ways to write inline functions present in
headers, and no, embedded developer being lazy does not mean they can
copy those functions into their proprietary module.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
