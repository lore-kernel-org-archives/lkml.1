Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYEOF0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYEOF0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 01:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbYEOF0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 01:26:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42401
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbYEOF0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 01:26:33 -0400
Date: Wed, 14 May 2008 22:26:28 -0700 (PDT)
Message-Id: <20080514.222628.237901651.davem@davemloft.net>
To: greg@kroah.com
Cc: shemminger@vyatta.com, fubar@us.ibm.com, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sysfs: remove error messages for -EEXIST case
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080515031458.GA4423@kroah.com>
References: <20080514181603.411e834f@extreme>
	<20080514.182637.211478588.davem@davemloft.net>
	<20080515031458.GA4423@kroah.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 14 May 2008 20:14:58 -0700

> Fair enough, I have no objection to these.
> 
> David, do you want me to take them through my tree?  Or are they
> dependant on the network core changes as well?  If so, I have no
> problem you taking them.  Feel free to add a:
> 	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> to them in that case.

I'll take them, thanks for reviewing and the signoff Greg.
