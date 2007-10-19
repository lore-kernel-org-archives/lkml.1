Return-Path: <linux-kernel-owner+w=401wt.eu-S937208AbXJST7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937208AbXJST7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936297AbXJST6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:58:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55420 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935935AbXJST6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:58:08 -0400
Date: Fri, 19 Oct 2007 21:59:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Adrian Bunk <bunk@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, zippel@linux-m68k.org
Subject: Re: [PATCH v3] kconfig: update kconfig-language text
Message-ID: <20071019195940.GA360@uranus.ravnborg.org>
References: <20070813113809.9a715e75.randy.dunlap@oracle.com> <20070813185431.GD18945@stusta.de> <20071019105348.08860145.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019105348.08860145.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 10:53:48AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add kconfig-language docs for mainmenu, def_bool, and def_tristate.
> Remove "requires" as a synonym of "depends on" since it was removed
> from  the parser in commit 247537b9a270b52cc0375adcb0fb2605a160cba5.

Thanks Randy - applied.

	Sam
