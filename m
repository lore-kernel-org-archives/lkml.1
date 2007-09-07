Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbXIGRcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbXIGRcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 13:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbXIGRcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 13:32:17 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:13763 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960AbXIGRcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 13:32:16 -0400
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070907172425.GA12977@uranus.ravnborg.org>
References: <200709051443.21522.vda.linux@googlemail.com>
	 <200709061157.44080.vda.linux@googlemail.com>
	 <1189091630.8490.1.camel@imap.mvista.com>
	 <200709061807.33740.vda.linux@googlemail.com>
	 <1189182671.6303.42.camel@imap.mvista.com>
	 <20070907172425.GA12977@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 10:19:58 -0700
Message-Id: <1189185598.7636.4.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-07 at 19:24 +0200, Sam Ravnborg wrote:
> Hi Daniel.
> 
> > > I did that before I posted patches to lkml.
> > > IOW: posted patches are not broken versus module loading.
> > 
> > Ok, this is more like the explanation I was looking for..
> > 
> > During this thread you seemed to indicate the patches you release
> > reduced the kernel ~10% , but now your saying that was pre-release ,
> > right? 
> 
> What are you after here?
> 
> If you read the inital post you see the actual savings and you also
> can read that it works wiht modules. The precentage can be calculated
> from these numbers if you are interested.

Right, but he contradicted that during the course of this thread.. Which
is why I'm asking about it..

Daniel

