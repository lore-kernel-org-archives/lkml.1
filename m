Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYJJGUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYJJGUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 02:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYJJGUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 02:20:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39128 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbYJJGUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 02:20:04 -0400
Date: Fri, 10 Oct 2008 08:19:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nick Warne <nick@ukfsn.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] doc/cdrom: Trvial documentation error, file not present
Message-ID: <20081010061927.GT19428@kernel.dk>
References: <20081005014624.0c8aa924@sauron.linicks.net> <20081009110630.32c0d2f7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009110630.32c0d2f7.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09 2008, Randy Dunlap wrote:
> On Sun, 5 Oct 2008 01:46:24 +0100 Nick Warne wrote:
> 
> > In Documentation/cdrom/ide-cd, from line 148 is:
> > 
> > "Lacking anything else, you could use the
> > cdtester program in Documentation/cdrom/sbpcd".
> > 
> > This file is not present in stable 2.6.26.5 at least.
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> The sbpcd tester program is not included in the kernel source tree,
> so remove the reference to it.

Applied

-- 
Jens Axboe

