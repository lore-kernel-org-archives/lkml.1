Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYDRNlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYDRNlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYDRNlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:41:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbYDRNlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:41:00 -0400
Message-ID: <4808A4E5.6060903@sandeen.net>
Date: Fri, 18 Apr 2008 08:40:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 released with bug, which leads to XFS crash?
References: <200804170949.36864.denys@visp.net.lb> <4807EDD6.8000705@sandeen.net> <20080418074041.GA9839@infradead.org> <200804181332.31177.denys@visp.net.lb>
In-Reply-To: <200804181332.31177.denys@visp.net.lb>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Fedoryshchenko wrote:
> AUFS(same as COSS, UFS, NULL) is way of handling with cache storage in squid, and nothing else. It is userspace and not involved deeply with kernel things.
> Since long long time i didn't had any single problem with it.
> Kernel is fully vanilla.

ah, ok.  I had assumed kernel module too, sorry.

-Eric
