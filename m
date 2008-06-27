Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbYF0VEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbYF0VEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbYF0VEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:04:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41700 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYF0VEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:04:35 -0400
Date: Fri, 27 Jun 2008 23:05:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] kernel-doc: handle/strip __init
Message-ID: <20080627210521.GC29245@uranus.ravnborg.org>
References: <20080619160329.1a4fe917.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619160329.1a4fe917.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 04:03:29PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> cc: David Brownell <dbrownell@users.sourceforge.net>
> 
> Handle __init in functions with kernel-doc notation by stripping the
> __init away from the output doc.  This is already being done for
> "__devinit".  This patch fixes these kernel-doc error/aborts:

Applied

	Sam
