Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbXGTGjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbXGTGjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbXGTGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:39:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58321 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbXGTGjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:39:37 -0400
Date: Fri, 20 Jul 2007 08:40:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jdike@addtoit.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fallout from kbuild changes
Message-ID: <20070720064049.GA19653@uranus.ravnborg.org>
References: <20070720010116.GB21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720010116.GB21668@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 02:01:16AM +0100, Al Viro wrote:
> 	Change in 'kbuild: do section mismatch check on full vmlinux'
> should've been replicated in arch/um/Makefile.

Thanks Al.

	Sam
