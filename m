Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbXK1PHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbXK1PHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbXK1PHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:07:06 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:41520 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbXK1PHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:07:04 -0500
Date: Wed, 28 Nov 2007 10:06:37 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: -rt doesn't compile for UML
Message-ID: <20071128150637.GA5518@c2.user-mode-linux.org>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 01:47:20PM +0100, Miklos Szeredi wrote:
> When writing a big file to a ubd disk, everything in uml slows down to
> a crawl, even though CPU usage is minimal.

What exactly is your test case?

I have some patches which theoretically should help I/O performance
which I've been sitting on because I can't find a case where they
help.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
