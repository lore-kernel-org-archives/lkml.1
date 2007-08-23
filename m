Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbXHWDjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbXHWDjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbXHWDiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:38:55 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52375 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759360AbXHWDiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:38:54 -0400
Date: Wed, 22 Aug 2007 23:38:39 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       vberk@ists.dartmouth.edu,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>
Subject: Re: [PATCH 2/2] UML - Fix x86_64 core dump crash
Message-ID: <20070823033839.GA17185@c2.user-mode-linux.org>
References: <20070822212530.GA14478@c2.user-mode-linux.org> <20070822144921.d057c654.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822144921.d057c654.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:49:21PM -0700, Andrew Morton wrote:
> This doesn't apply to current mainline in ways which I'm not entirely
> comfortable fixing.  (it assumes the presence of queued-for-2.6.24 things).

Hmmm, yeah.

> Does the below still work?

Yup, it looks fine.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
