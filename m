Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbXLUHHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbXLUHHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXLUHG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:06:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46458 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbXLUHG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:06:56 -0500
Date: Fri, 21 Dec 2007 07:06:50 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm 01/43] user_regset header
Message-ID: <20071221070650.GA4345@infradead.org>
References: <20071220115200.C767E26F98A@magilla.localdomain> <20071220115357.D1E1326F98A@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220115357.D1E1326F98A@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 03:53:57AM -0800, Roland McGrath wrote:
> +/*
> + * User-mode machine state access
> + *
> + * Copyright (C) 2007 Red Hat, Inc.  All rights reserved.
> + *
> + * This copyrighted material is made available to anyone wishing to use,
> + * modify, copy, or redistribute it subject to the terms and conditions
> + * of the GNU General Public License v.2.
> + *
> + * Red Hat Author: Roland McGrath.

What's a Red Hat Author?  Sorry for the nitpicking, but why don't you
just use Author like everyone else?

