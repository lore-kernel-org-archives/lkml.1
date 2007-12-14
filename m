Return-Path: <linux-kernel-owner+w=401wt.eu-S933618AbXLNTjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbXLNTjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765575AbXLNTdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:33:19 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:35446 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764320AbXLNTdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:33:17 -0500
Date: Fri, 14 Dec 2007 14:33:14 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Francisco Alecrim <francisco.alecrim@indt.org.br>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       dbrownell@users.sourceforge.net, kyle@parisc-linux.org,
       dmitry.torokhov@gmail.com, hcegtvedt@atmel.com
Subject: Re: [PATCH 2/6] drivers/parisc/ccio-dma.c: clean up remove duplicated headers
Message-ID: <20071214193314.GA11163@fattire.cabal.ca>
References: <1197658610-4558-1-git-send-email-francisco.alecrim@indt.org.br> <1197658610-4558-2-git-send-email-francisco.alecrim@indt.org.br> <1197658610-4558-3-git-send-email-francisco.alecrim@indt.org.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197658610-4558-3-git-send-email-francisco.alecrim@indt.org.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 02:56:46PM -0400, Francisco Alecrim wrote:
> Remove duplicated headers in drivers/parisc/ccio-dma.c:
> drivers/parisc/ccio-dma.c: linux/proc_fs.h is included more than once.
> 

Seems kind of pointless, but I'll apply it.

cheers, Kyle
