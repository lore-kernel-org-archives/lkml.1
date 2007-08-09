Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbXHIUHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbXHIUHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXHIUHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:07:18 -0400
Received: from lazybastard.de ([212.112.238.170]:59376 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXHIUHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:07:15 -0400
Date: Thu, 9 Aug 2007 22:03:16 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch 02/18] include/linux/logfs.h
Message-ID: <20070809200315.GC9036@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org> <20070808161428.GD15319@lazybastard.org> <200708090056.30350.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708090056.30350.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 August 2007 00:56:29 +0200, Arnd Bergmann wrote:
> On Wednesday 08 August 2007, Jörn Engel wrote:
> > +++ linux-2.6.21logfs/include/linux/logfs.h     2007-08-08 02:57:37.000000000 +0200
> > @@ -0,0 +1,500 @@
> > +/*
> > + * fs/logfs/logfs.h
> > + *
> 
> The comment does not match the file name. Better remove the file names
> entirely from introduction comments.

Maybe.  This file needs to get moved again anyway.

Jörn

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan
