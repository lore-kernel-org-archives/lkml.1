Return-Path: <linux-kernel-owner+w=401wt.eu-S1033335AbXHMSnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033335AbXHMSnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764013AbXHMSZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:25:38 -0400
Received: from namei.org ([69.55.235.186]:55055 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031940AbXHMSZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:25:34 -0400
Date: Mon, 13 Aug 2007 11:24:58 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Joe Perches <joe@perches.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH] [426/2many] MAINTAINERS - SELINUX SECURITY MODULE
In-Reply-To: <1187025988.10249.148.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708131124080.13442@us.intercode.com.au>
References: <46bffbb2.DuT+iothoJWb9xhc%joe@perches.com> 
 <Pine.LNX.4.64.0708130512560.10561@us.intercode.com.au>
 <1187025988.10249.148.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yOn Mon, 13 Aug 2007, Joe Perches wrote:

> On Mon, 2007-08-13 at 05:13 -0700, James Morris wrote:
> > On Sun, 12 Aug 2007, joe@perches.com wrote:
> > > -L:	linux-kernel@vger.kernel.org (kernel issues)
> > > -L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
> > > +L:	linux-kernel@vger.kernel.org
> > > +L:	selinux@tycho.nsa.gov (subscribers-only)
> > >  W:	http://www.nsa.gov/selinux
> > >  S:	Supported
> > > +F:	include/linux/selinux*
> > > +F:	security/selinux/
> > 
> > Why are you changing descriptions of the maiking lists ?
> 
> Ease of script identification of subscribers-only lists

Fix your script to handle the original format.  Sheesh.



-- 
James Morris
<jmorris@namei.org>
