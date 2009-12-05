Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbZLEUYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbZLEUYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZLEUYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:24:13 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:42404 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbZLEUYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:24:12 -0500
Date: Sat, 5 Dec 2009 20:22:51 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-arch@vger.kernel.org, lethal@linux-sh.org, rmk@arm.linux.org.uk,
       davem@davemloft.net, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix broken aliasing checks for MAP_FIXED on sparc32,
 mips, arm and sh
Message-ID: <20091205202251.GA475@linux-mips.org>
References: <E1NH12k-0001gw-NA@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NH12k-0001gw-NA@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 08:15:50PM +0000, Al Viro wrote:

After our IRC chat I've already applied an commit that is identical to the
MIPS segment of your patch.

Thanks!

  Ralf
