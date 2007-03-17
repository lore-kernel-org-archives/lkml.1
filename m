Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbXCQGvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbXCQGvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 02:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXCQGvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 02:51:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48998 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbXCQGvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 02:51:10 -0400
Date: Sat, 17 Mar 2007 07:51:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] dont use obsolete index() function in lxdialog
Message-ID: <20070317065137.GC26842@uranus.ravnborg.org>
References: <200703170237.07934.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703170237.07934.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 02:37:07AM -0400, Mike Frysinger wrote:
> The index() function is obsolete, use strchr() instead.

Thanks, applied.

	Sam
