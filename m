Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXEFEgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXEFEgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 00:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbXEFEgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 00:36:50 -0400
Received: from 1wt.eu ([62.212.114.60]:2497 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbXEFEgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 00:36:49 -0400
Date: Sun, 6 May 2007 06:36:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: Zbigniew Baniewski <zb@ispid.com.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "modularized" 2.4.34.4  ->  ide-core "unresolved symbols"
Message-ID: <20070506043645.GF943@1wt.eu>
References: <20070505194922.GA13176@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505194922.GA13176@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 09:49:22PM +0200, Zbigniew Baniewski wrote:
> Hallo,
> 
> I was trying to make "modularized kernel" (s.c. "Debian way") recently, yes,
> I made even kernel.deb package - but at the installation, I'm still getting
> an error: "ide-core: unresolved symbols".
> 
> Making a quick search with Google I could see, it did occur to many other
> people even long ago. There was even a patch introduced - which, I believe,
> is in the 2.4.34.4 "drivers/ide" sub-dir - unfortunately it seems, that the
> patch is working no more.
> 
> Perhaps there is another patch available for 2.4.34.4 ?

Could you please be a bit more precise :
  - config
  - what are the unresolved symbols ?
  - link to the patch you are talking about ?

Thanks,
Willy

