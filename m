Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbXHXEDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbXHXEDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 00:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbXHXEDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 00:03:11 -0400
Received: from ozlabs.org ([203.10.76.45]:55256 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXHXEDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 00:03:10 -0400
Subject: Re: [PATCH] lguest should depend on CONFIG_FUTEX
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       Gabriel C <nix.or.die@googlemail.com>
In-Reply-To: <20070823132514.GD31289@localhost.sw.ru>
References: <20070823132514.GD31289@localhost.sw.ru>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 09:53:05 +1000
Message-Id: <1187913185.20041.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 17:25 +0400, Alexey Dobriyan wrote:
> It uses get_futex_key().
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Good catch.  Thanks, sent to Linus.

Cheers,
Rusty.

