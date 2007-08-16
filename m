Return-Path: <linux-kernel-owner+w=401wt.eu-S934352AbXHPQlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbXHPQlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbXHPQlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:41:05 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44671 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbXHPQlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:41:03 -0400
Date: Thu, 16 Aug 2007 09:39:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, stable@kernel.org,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>, giedrius@su.lt,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [stable] [PATCH] UML - Add a .note.SuSE section
Message-ID: <20070816163906.GF3672@sequoia.sous-sol.org>
References: <20070816162428.GA8128@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816162428.GA8128@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Dike (jdike@addtoit.com) wrote:
> [ This is both 2.6.24 and -stable material ]
> 
> SuSE seems to require that binaries have a .note.SuSE section.
> Without it, UML segfaults if any parameters are passed on the command
> line.

Huh!?  Why do we need a SuSE section?
thanks,
-chris
