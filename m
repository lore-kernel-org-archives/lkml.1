Return-Path: <linux-kernel-owner+w=401wt.eu-S934456AbXHPQgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbXHPQgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761246AbXHPQfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:35:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36607 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762580AbXHPQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:35:12 -0400
Subject: Re: [PATCH] UML - Add a .note.SuSE section
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>, giedrius@su.lt
In-Reply-To: <20070816162428.GA8128@c2.user-mode-linux.org>
References: <20070816162428.GA8128@c2.user-mode-linux.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 16 Aug 2007 09:30:56 -0700
Message-Id: <1187281856.2663.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-08-16 at 12:24 -0400, Jeff Dike wrote:
> [ This is both 2.6.24 and -stable material ]
> 
> SuSE seems to require that binaries have a .note.SuSE section.
> Without it, UML segfaults if any parameters are passed on the command
> line.


this sounds like something really stupid and bad... why would the kernel
need to have a per-distro note section???


