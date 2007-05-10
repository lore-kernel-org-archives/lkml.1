Return-Path: <linux-kernel-owner+w=401wt.eu-S1761476AbXEJMBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761476AbXEJMBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761010AbXEJMBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:01:21 -0400
Received: from [198.99.130.12] ([198.99.130.12]:42232 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbXEJMBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:01:20 -0400
Date: Thu, 10 May 2007 07:55:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 5/6] UML - Monitor stack usage
Message-ID: <20070510115529.GA4969@c2.user-mode-linux.org>
References: <20070509202722.GA22464@c2.user-mode-linux.org> <20070509210738.a06b005a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509210738.a06b005a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:07:38PM -0700, Andrew Morton wrote:
> but, but.  We already have CONFIG_DEBUG_STACK_USAGE?

Whoops, that's not exactly what I want, but it's close enough to let
me throw out some code.

Drop that and I'll send a fixed version.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
