Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYJPGJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYJPGJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYJPGIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:08:51 -0400
Received: from www.steve.org.uk ([80.68.85.46]:56765 "EHLO skx.xen-hosting.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYJPGIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:08:51 -0400
Date: Thu, 16 Oct 2008 07:08:29 +0100
From: Steve Kemp <steve@steve.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: trivial patches: Should we care about control reaches end of
	non-void function
Message-ID: <20081016060829.GA21294@steve.org.uk>
References: <20081015180732.GA4119@steve.org.uk> <20081015232625.547ebe9e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015232625.547ebe9e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Oct 15, 2008 at 23:26:25 +0100, Alan Cox wrote:

> Probably better to mark BUG() properly for the compiler.

  Good idea.

  It seems this was attempted previously:

     http://www.uwsg.iu.edu/hypermail/linux/kernel/0402.0/0843.html

  The patch needs some updating to move it into the current location,
 but passes a compile test at least.

Steve
-- 
Managed Anti-Spam Service
http://mail-scanning.com/

