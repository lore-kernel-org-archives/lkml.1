Return-Path: <linux-kernel-owner+w=401wt.eu-S973707AbXHMR2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973707AbXHMR2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032550AbXHMR0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:26:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3240 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032509AbXHMR0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:26:35 -0400
Subject: Re: [PATCH] [426/2many] MAINTAINERS - SELINUX SECURITY MODULE
From: Joe Perches <joe@perches.com>
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@parisplace.org>
In-Reply-To: <Pine.LNX.4.64.0708130512560.10561@us.intercode.com.au>
References: <46bffbb2.DuT+iothoJWb9xhc%joe@perches.com>
	 <Pine.LNX.4.64.0708130512560.10561@us.intercode.com.au>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 10:26:28 -0700
Message-Id: <1187025988.10249.148.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 05:13 -0700, James Morris wrote:
> On Sun, 12 Aug 2007, joe@perches.com wrote:
> > -L:	linux-kernel@vger.kernel.org (kernel issues)
> > -L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
> > +L:	linux-kernel@vger.kernel.org
> > +L:	selinux@tycho.nsa.gov (subscribers-only)
> >  W:	http://www.nsa.gov/selinux
> >  S:	Supported
> > +F:	include/linux/selinux*
> > +F:	security/selinux/
> 
> Why are you changing descriptions of the maiking lists ?

Ease of script identification of subscribers-only lists


