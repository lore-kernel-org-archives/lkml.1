Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbYK3FjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbYK3FjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 00:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYK3FjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 00:39:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45317
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbYK3FjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 00:39:04 -0500
Date: Sat, 29 Nov 2008 21:39:03 -0800 (PST)
Message-Id: <20081129.213903.155135966.davem@davemloft.net>
To: tilman@imap.cc
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] gigaset: remove unnecessary poll method
From: David Miller <davem@davemloft.net>
In-Reply-To: <9b6d85e917139005e83f6b93460d71c4220cc880.1227876791.git.tilman@imap.cc>
References: <1227876791.git.tilman@imap.cc>
	<9b6d85e917139005e83f6b93460d71c4220cc880.1227876791.git.tilman@imap.cc>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sat, 29 Nov 2008 23:41:07 +0100 (CET)

> The N_GIGASET_M101 line discipline implemented by the ser_gigaset
> driver does not transfer any data from/to userspace through the
> tty interface. Therefore a poll method is not needed.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied to net-next-2.6
