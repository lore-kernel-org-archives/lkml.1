Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYDRAkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYDRAkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 20:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYDRAjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 20:39:52 -0400
Received: from sandeen.net ([209.173.210.139]:26315 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYDRAjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 20:39:51 -0400
Message-ID: <4807EDD6.8000705@sandeen.net>
Date: Thu, 17 Apr 2008 19:39:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 released with bug, which leads to XFS crash?
References: <200804170949.36864.denys@visp.net.lb>
In-Reply-To: <200804170949.36864.denys@visp.net.lb>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Fedoryshchenko wrote:
> Hi again
> 
> I reported about http://bugzilla.kernel.org/show_bug.cgi?id=10421 , and it is triggerable on different loaded servers with XFS (squid with aufs),

Oh, aufs was not listed in the bug report.  that's an out of tree
module, right?  Is it completely up to date and safe with 2.6.25?

-Eric
