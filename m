Return-Path: <linux-kernel-owner+w=401wt.eu-S941770AbXHJUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941770AbXHJUIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934891AbXHJUIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:08:07 -0400
Received: from hall.aurel32.net ([88.191.38.19]:58885 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933511AbXHJUIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:08:05 -0400
Date: Fri, 10 Aug 2007 22:08:01 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-ID: <20070810200801.GA16714@hall.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org
References: <20070809224254.11f42716.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
X-Mailer: Mutt 1.5.13 (2006-08-11)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:42:54PM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/
> 
> - Various problems from 2.6.23-rc2-mm1 were fixed
> 

I have just noticed that the B44 drivers now depends on BROKEN. It was
the already case in 2.6.23-rc2-mm1 but not 2.6.23-rc1-mm2. Is it
something really wanted?

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
