Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZATFAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZATFAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 00:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZATFAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 00:00:11 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:41104 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZATFAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 00:00:10 -0500
Date: Mon, 19 Jan 2009 23:59:59 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Shane Hathaway <shane@hathawaymix.org>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] UML: spurious interrupt freezes guest
Message-ID: <20090120045959.GA18187@c2.user-mode-linux.org>
References: <49754AB5.3000701@hathawaymix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49754AB5.3000701@hathawaymix.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 08:53:25PM -0700, Shane Hathaway wrote:
> A new instance of user mode linux that I created over the past couple of
> days worked pretty well except that it had a habit of freezing after a
> few minutes.  Every time it froze, the last message on the console was
> either:
> 
> spurious interrupt in ubd_handler, err = 4

What version and what's the workload?

     	     	 	Jeff
