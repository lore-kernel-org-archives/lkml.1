Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbXHPSg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbXHPSg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 14:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXHPSgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 14:36:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:56830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbXHPSgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 14:36:16 -0400
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, stable@kernel.org,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>, giedrius@su.lt,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - Add a .note.SuSE section
References: <20070816162428.GA8128@c2.user-mode-linux.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 16 Aug 2007 21:30:17 +0200
In-Reply-To: <20070816162428.GA8128@c2.user-mode-linux.org>
Message-ID: <p73vebf1dme.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike <jdike@addtoit.com> writes:

> [ This is both 2.6.24 and -stable material ]
> 
> SuSE seems to require that binaries have a .note.SuSE section.
> Without it, UML segfaults if any parameters are passed on the command
> line.

This doesn't make any sense. You must have misanalyzed this.

-Andi

