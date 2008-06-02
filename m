Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYFBCtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYFBCtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 22:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbYFBCtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 22:49:03 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:46436 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbYFBCtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 22:49:01 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
In-Reply-To: <200806012349.29538.arnd@arndb.de>
References: <200805311737.58991.arnd@arndb.de> <48421D65.8040301@lougher.demon.co.uk> <20080601122818.GA3687@shareable.org> <200806012349.29538.arnd@arndb.de>
Date: Mon, 02 Jun 2008 11:48:22 +0900
Message-ID: <9785.1212374902@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd Bergmann:
> Besides, there are a many more problems with unionfs, which have
> all been mentioned in the previous review cycles. Aufs doesn't
> address those either AFAIK, with the exception of at least
> not making additional copies in the page cache when writing to
> a file.

Hello Arnd,

While I don't have particular objection to your idea and approach to
cramfs, I'd point out that modern LiveCDs tend to save their
modifications to disk.
And AUFS did address all known problems. If there left something, please
let me know.


Junjiro Okajima
