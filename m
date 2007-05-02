Return-Path: <linux-kernel-owner+w=401wt.eu-S2993400AbXEBPpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993400AbXEBPpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993380AbXEBPpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:45:42 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42390 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993338AbXEBPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:45:40 -0400
Date: Wed, 2 May 2007 11:41:31 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@osdl.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 4/6] UML - free() wrapper should call libc free
Message-ID: <20070502154131.GE6752@c2.user-mode-linux.org>
References: <20070501182158.GA8358@c2.user-mode-linux.org> <4637FC1D.4040300@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637FC1D.4040300@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 12:49:01PM +1000, Nick Piggin wrote:
> I want to get rid of PG_reserved eventually. Is it possible to use PG_arch_1
> for this?

Yup.

Andrew - Feel free to drop this or just sit on it until I send a
replacement.  Whichever is easier.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
