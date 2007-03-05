Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXCEUbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXCEUbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932341AbXCEUbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:31:21 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:49047 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbXCEUbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:31:21 -0500
Date: Mon, 5 Mar 2007 15:22:11 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, user-mode-linux@lists.sourceforge.net
Subject: Re: nonlinear vma problem in uml
Message-ID: <20070305202211.GC7320@ccure.user-mode-linux.org>
References: <E1HNGpQ-0005yE-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HNGpQ-0005yE-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 12:06:20AM +0100, Miklos Szeredi wrote:
> _PAGE_PROTNONE conflicts with the lowest bit of pgoff.  This causes
> all sorts of weirdness when nonlinear mappings are used.
> 
> Took me a good half day to track this down.

Thanks, I'll send this in.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
