Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbXI1QrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbXI1QrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXI1QrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:47:03 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40879 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbXI1QrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:47:02 -0400
Date: Fri, 28 Sep 2007 12:46:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use array_size macro
Message-ID: <20070928164655.GA7986@c2.user-mode-linux.org>
References: <46FCDBE9.8030406@tiscali.nl> <46FCDDDF.8020500@tiscali.nl> <20070928131514.GA5209@c2.user-mode-linux.org> <46FD1372.70608@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FD1372.70608@tiscali.nl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 04:45:06PM +0200, Roel Kluin wrote:
> Thanks for noting me. I usually pull the masters branch, so my
> previously submitted patches are against that. Apparently I have to
> apply the -mm patchset before sending patches. Is there a git branch
> to pull from for that? 

I have a lot of stuff in -mm, currently.  So, if you're messing around
inside UML, -mm is a good place to look.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
