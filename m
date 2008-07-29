Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYG2O7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYG2O7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYG2O7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:59:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55388 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYG2O7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:59:32 -0400
Date: Tue, 29 Jul 2008 08:59:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Mark Asselstine <mark.asselstine@windriver.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Removal of the deprecated cli() sti() functions.
Message-ID: <20080729145929.GE28989@parisc-linux.org>
References: <1217342763-19568-1-git-send-email-mark.asselstine@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217342763-19568-1-git-send-email-mark.asselstine@windriver.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 10:46:03AM -0400, Mark Asselstine wrote:
> These functions have been deprecated for some time now
> but remained until all legacy callers could be removed.
> With a few commits in 2.6.26 this has happened so now
> we can remove these deprecated functions.
> 
> Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>

Yay!

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
