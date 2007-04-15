Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbXDOJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbXDOJrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXDOJrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:47:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1078 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751924AbXDOJrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:47:19 -0400
Date: Sun, 15 Apr 2007 09:47:07 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, davidsen@tmr.com, randy.dunlap@oracle.com,
       dada1@cosmosbay.com, Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
Message-ID: <20070415094706.GB10097@ucw.cz>
References: <461A4C1E.3070309@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461A4C1E.3070309@ru.mvista.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +       return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
> +                           "Nivcsw:\t%lu\n",
> +                           p->nvcsw,
> +                           p->nivcsw);

We don't encrypt variable names like this.
							Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
