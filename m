Return-Path: <linux-kernel-owner+w=401wt.eu-S1161477AbXBGXnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161477AbXBGXnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161480AbXBGXnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:43:49 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:62850 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161477AbXBGXnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:43:49 -0500
Date: Wed, 7 Feb 2007 15:38:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Oleg Verych <olecom@flower.upol.cz>, Alexey Dobriyan <adobriyan@gmail.com>,
       torvalds@osdl.org, sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [patch, fix build regression] kbuild: Kbuild.include avoid
 using spaces in call arguments
Message-Id: <20070207153848.e02d355d.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0702080029030.14457@scrub.home>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
	<Pine.LNX.4.64.0702071846180.14457@scrub.home>
	<20070207220435.GC22699@flower.upol.cz>
	<Pine.LNX.4.64.0702080029030.14457@scrub.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 00:34:50 +0100 (CET) Roman Zippel wrote:

> Hi,
> 
> On Wed, 7 Feb 2007, Oleg Verych wrote:
> 
> > > Linus, please revert. Thanks.
> >  
> > Roman, while it went so fast to Linus, i didn't expect that, let me
> > try to fix all this with this little patch.
> 
> Sorry, it needs more changes, the patch simply wasn't ready.

Can you be more explicit?  and then it should get some time
in -mm, hopefully.

Thanks,
---
~Randy
