Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYHDOEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYHDOEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYHDODz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:03:55 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:37061 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYHDODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:03:54 -0400
Date: Mon, 4 Aug 2008 10:03:28 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Installer
Message-ID: <20080804140328.GA6683@c2.user-mode-linux.org>
References: <93655eb70808031350q16a5765bk3125e53bd042ba0e@mail.gmail.com> <20080803210051.GF7442@cs181140183.pp.htv.fi> <93655eb70808032045vd6130e9m147d3e3ae8b159b5@mail.gmail.com> <93655eb70808032046y594f38a3u16b7fa2cc6291b1d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93655eb70808032046y594f38a3u16b7fa2cc6291b1d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 09:16:52AM +0530, Satish Eerpini wrote:
> but in the process i am stuck at deciding the no of files that will be
> compiled , given that representing the entire compilation
> process as a progress bar , would give a clear idea of " how much is
> over" and "how much is left" !!!

Look at make -n.  I suspect that its output won't match reality
perfectly, but it's probably good enough for a progress bar.

	       	    	     Jeff

-- 
Work email - jdike at linux dot intel dot com
