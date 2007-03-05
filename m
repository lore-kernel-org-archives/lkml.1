Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXCEWPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXCEWPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbXCEWPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:15:22 -0500
Received: from [198.99.130.12] ([198.99.130.12]:49461 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbXCEWPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:15:21 -0500
Date: Mon, 5 Mar 2007 17:06:34 -0500
From: Jeff Dike <jdike@addtoit.com>
To: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/11] Uml simple fixes
Message-ID: <20070305220634.GC7702@ccure.user-mode-linux.org>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 09:42:29PM +0100, Paolo 'Blaisorblade' Giarrusso wrote:
> Some tested UML fixes - should be applied for 2.6.21.

ACK on all of these except for 1, which won't apply to current -mm,
and 4, which might need some more work.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
