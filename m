Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbXI0MoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbXI0MoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXI0MoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:44:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:48005 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752599AbXI0MoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:44:05 -0400
Cc: hch@lst.de, geoff@gclare.org.uk, subrata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 27 Sep 2007 14:44:03 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <20070927124045.GL3400@zakalwe.fi>
Message-ID: <20070927124403.170750@gmx.net>
MIME-Version: 1.0
References: <46FB9FB9.8080201@gmx.net> <20070927124045.GL3400@zakalwe.fi>
Subject: Re: Revised signalfd man-page
To: Heikki Orsila <shdl@zakalwe.fi>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19Pza4EzixP/cB21D9GkvinmfkJZ7aZZAuZSlpj2L
 uEQ5NrSUX+hxB/CzadFBlL27r+KqOhaxDccQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: oZzDc48xbmwoVdTtEzZLrHpPUzc4chG+
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Sep 27, 2007 at 02:19:05PM +0200, Michael Kerrisk wrote:
> >     uint28_t  pad[\fIX\fP];  /* Pad size to 128 bytes (allow space
> >                           additional fields in the future) */
> 
> I think you mean uint8_t..

Yep -- I sure do....

thanks,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

