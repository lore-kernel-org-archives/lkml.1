Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZCAIUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZCAIUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 03:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZCAIUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 03:20:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38392
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbZCAIUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 03:20:30 -0500
Date: Sun, 01 Mar 2009 00:20:11 -0800 (PST)
Message-Id: <20090301.002011.75128637.davem@davemloft.net>
To: sam@ravnborg.org
Cc: christopher.leech@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net headers: cleanup dcbnl.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090227211305.GA12654@uranus.ravnborg.org>
References: <20090227200136.31557.53143.stgit@localhost.localdomain>
	<20090227211305.GA12654@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 27 Feb 2009 22:13:05 +0100

> On Fri, Feb 27, 2009 at 12:01:36PM -0800, Chris Leech wrote:
> > 1) add an include for <linux/types.h>
> > 2) change dcbmsg.dcb_family from unsigned char to __u8 to be more
> >    consistent with use of kernel types
> > 
> > Signed-off-by: Chris Leech <christopher.leech@intel.com>
> Thanks Chris.
> 
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Applied.
