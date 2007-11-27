Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbXK0WUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbXK0WUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXK0WU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:20:28 -0500
Received: from [198.99.130.12] ([198.99.130.12]:37528 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbXK0WU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:20:27 -0500
Date: Tue, 27 Nov 2007 17:20:20 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.neta
Subject: Re: [uml-devel] leak in do_ubd_request
Message-ID: <20071127222020.GA10096@c2.user-mode-linux.org>
References: <E1Ix3Du-0002aL-Ac@dorka.pomaz.szeredi.hu> <E1Ix58o-0004J5-Mz@dorka.pomaz.szeredi.hu> <20071127201105.GA9332@c2.user-mode-linux.org> <E1Ix73b-0004aI-Px@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ix73b-0004aI-Px@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 09:29:23PM +0100, Miklos Szeredi wrote:
> Sure.  The patch works for me, but please check that it also makes
> sense.

I did - it's a straight-forward leak and fix.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
