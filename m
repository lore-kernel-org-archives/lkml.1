Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbYLHInN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbYLHInN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 03:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYLHIm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 03:42:58 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60588 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYLHIm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 03:42:57 -0500
Subject: Re: [PATCH] Fix incorrect use of loose in slub.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20081205030808.32351.74011.stgit@marcab.local.tull.net>
References: <20081205030808.32351.74011.stgit@marcab.local.tull.net>
Date: Mon, 08 Dec 2008 10:42:54 +0200
Message-Id: <1228725774.31442.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 14:08 +1100, Nick Andrew wrote:
> Fix incorrect use of loose in slub.c
> 
> It should be 'lose', not 'loose'.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Applied, thanks!

