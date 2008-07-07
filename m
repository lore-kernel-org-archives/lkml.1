Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYGGQ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYGGQ6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYGGQ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:58:39 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:56123 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYGGQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:58:39 -0400
Date: Mon, 7 Jul 2008 12:58:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix extern inline errors with gcc 4.3.0
Message-ID: <20080707165802.GA7747@c2.user-mode-linux.org>
References: <1214488251-20927-1-git-send-email-bhalevy@panasas.com> <20080627162645.GC8381@c2.user-mode-linux.org> <7225594ED4A1304C9E43D030A886D221050BE1@daytona.int.panasas.com> <48673A9B.8050907@panasas.com> <20080630162201.GC6643@c2.user-mode-linux.org> <48690BC7.5060809@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48690BC7.5060809@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 07:37:27PM +0300, Benny Halevy wrote:
> This isn't exactly aligned with the comment above.
> Should be -lt 0400, as in 22eecde2f9034764a3fd095eecfa3adfb8ec9a98?

Oops, right.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
