Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYKFJja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYKFJja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYKFJjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:39:19 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37843 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbYKFJjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:39:18 -0500
Subject: Re: [PATCH] Kconfig: SLUB is the default slab allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: trivial@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org
In-Reply-To: <49121BAB.3030403@simon.arlott.org.uk>
References: <49121BAB.3030403@simon.arlott.org.uk>
Date: Thu, 06 Nov 2008 11:40:14 +0200
Message-Id: <1225964414.31559.13.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 22:18 +0000, Simon Arlott wrote:
> In 2007, a0acd820807680d2ccc4ef3448387fcdbf152c73 changed the default 
> slab allocator to SLUB, but the SLAB help text still says SLAB is the 
> default. This change fixes that.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

Applied, thanks!

