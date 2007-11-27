Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbXK0UL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbXK0UL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbXK0ULU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:11:20 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:36896 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbXK0ULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:11:19 -0500
Date: Tue, 27 Nov 2007 15:11:05 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] leak in do_ubd_request
Message-ID: <20071127201105.GA9332@c2.user-mode-linux.org>
References: <E1Ix3Du-0002aL-Ac@dorka.pomaz.szeredi.hu> <E1Ix58o-0004J5-Mz@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ix58o-0004J5-Mz@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 07:26:38PM +0100, Miklos Szeredi wrote:
> +				kfree(io_req);

Whoops, nice catch.

Can you sign that off for me?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
