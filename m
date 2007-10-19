Return-Path: <linux-kernel-owner+w=401wt.eu-S934715AbXJSTKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715AbXJSTKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXJSTKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:10:43 -0400
Received: from lazybastard.de ([212.112.238.170]:55588 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbXJSTKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:10:43 -0400
Date: Fri, 19 Oct 2007 21:06:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Samuel Tardieu <sam@rfc1149.net>
Cc: linux-mtd@lists.infradead.org, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eccbuf is statically defined and always evaluate to true
Message-ID: <20071019190604.GJ26913@lazybastard.org>
References: <20071019174155.80782C408E@mail2.rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071019174155.80782C408E@mail2.rfc1149.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 October 2007 19:26:35 +0200, Samuel Tardieu wrote:
> 
> ---
>  drivers/mtd/devices/doc2000.c     |    4 ++--
>  drivers/mtd/devices/doc2001plus.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Acked-by: Joern Engel <joern@logfs.org>

I assume you don't actually use this driver and just ran make
randconfig or allyesconfig or so..

Jörn

-- 
Science is like sex: sometimes something useful comes out,
but that is not the reason we are doing it.
-- Richard Feynman
