Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbXGZAlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbXGZAlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXGZAlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:41:44 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:28676 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbXGZAln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:41:43 -0400
X-IronPort-AV: i="4.16,582,1175486400"; 
   d="scan'208"; a="46524099:sNHT27061216"
Subject: Re: [GIT PULL try#2] Blackfin update
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bryan Wu <bryan.wu@analog.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707251125140.3607@woody.linux-foundation.org>
References: <1185377216.12354.12.camel@roc-laptop>
	 <alpine.LFD.0.999.0707251125140.3607@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 26 Jul 2007 08:41:38 +0800
Message-Id: <1185410498.13974.7.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 26 Jul 2007 00:41:41.0952 (UTC) FILETIME=[BC101400:01C7CF1D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 11:26 -0700, Linus Torvalds wrote:
> 
> On Wed, 25 Jul 2007, Bryan Wu wrote:
> > 
> > Please pull from 'for-linus' branch of
> 
> This really is too big for post-rc1.
> 
> I realize that this is all blackfin-only, and that it doesn't matter from 
> a practical standpoint, but I want you guys to learn to follow the merge 
> window, and the only way I can do that is by enforcing it.
> 
> 			Linus

Exactly. In the 2.6.23-rc1 merge window, I am trying to submit blackfin
driver patches and other new stuffs. So put those bug fixing and some
small updates in this series.

I will review the series again, submit critical bug fixing in rc2 and
maybe split rest of them into following -rc.

Thanks Jeff, after using you script, I generate this big email. It's
beautiful but I missed merge window.

Thanks a lot
Best Regards,
- Bryan Wu
