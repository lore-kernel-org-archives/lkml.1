Return-Path: <linux-kernel-owner+w=401wt.eu-S936805AbXGZUs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936805AbXGZUs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933688AbXGZUsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:48:22 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1029 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397AbXGZUsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:48:21 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] i2o: defined but not used.
Date: Thu, 26 Jul 2007 22:47:41 +0200
User-Agent: KMail/1.9.7
Cc: Sebastian Siewior <sebastian@breakpoint.cc>, linux-kernel@vger.kernel.org
References: <20070720225817.607502287@ayoka.breakpoint.cc> <20070721033133.ed47aa6a.akpm@linux-foundation.org>
In-Reply-To: <20070721033133.ed47aa6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262247.42795.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 21 July 2007, Andrew Morton wrote:

> On Sat, 21 Jul 2007 00:58:01 +0200 Sebastian Siewior 
<sebastian@breakpoint.cc> wrote:
> > Got with randconfig
>
> randconfig apparently generates impossible configs.  Please always
> run `make oldconfig' after the randconfig, then do the test build.

If that should make any difference, that would be a bug and I'd like to see 
that .config.

bye, Roman
