Return-Path: <linux-kernel-owner+w=401wt.eu-S1762518AbYHFUQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762518AbYHFUQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760136AbYHFUPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:15:45 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:42562 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758365AbYHFUPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:15:44 -0400
Date: Wed, 6 Aug 2008 22:14:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] KBUILD:  Extend "menuconfig" for modules to simplify Kconfig file.
Message-ID: <20080806201445.GA17518@uranus.ravnborg.org>
References: <alpine.LFD.1.10.0808041328440.6174@localhost.localdomain> <20080804104511.2e02f15e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804104511.2e02f15e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 10:45:11AM -0700, Randy Dunlap wrote:
> On Mon, 4 Aug 2008 13:31:32 -0400 (EDT) Robert P. J. Day wrote:
> 
> > 
> > Given that the init/Kconfig file uses a "menuconfig" directive for
> > modules already, might as well wrap all the submenu entries in an "if"
> > to toss all those dependencies.
> > 
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> Looks good to me.  and tested.
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied.

	Sam
