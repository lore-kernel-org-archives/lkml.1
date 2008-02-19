Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYBSEvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYBSEvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYBSEu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:50:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43077
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbYBSEu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:50:57 -0500
Date: Mon, 18 Feb 2008 20:51:34 -0800 (PST)
Message-Id: <20080218.205134.15506436.davem@davemloft.net>
To: panther@balabit.hu
Cc: rjw@sisk.pl, jkosina@suse.cz, zdenek.kabelac@gmail.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: My system stops during startup with curretn git tree of
 2.6.25-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <47B9BA73.7020909@balabit.hu>
References: <47B9928A.60202@balabit.hu>
	<200802181741.09046.rjw@sisk.pl>
	<47B9BA73.7020909@balabit.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laszlo Attila Toth <panther@balabit.hu>
Date: Mon, 18 Feb 2008 18:03:47 +0100

> Hello,
> 
> Rafael J. Wysocki wrote:
> > On Monday, 18 of February 2008, Laszlo Attila Toth wrote:
> >
> > 
> > All in all, I gather you wanted me to test the patch below. :-)
> > 
> > Yes, that helps.
> 
> Thanks for the testing. Dave already reverted the patch, also I don't 
> know I should resend it or leave it as is.

After this sits and gets testing and feedback for a few days
you'll need to resubmit the entire original patch with these
fixes added on top.

For now, it's staying reverted.
