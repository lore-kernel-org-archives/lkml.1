Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYIQWXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYIQWXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbYIQWX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:23:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59992
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbYIQWX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:23:26 -0400
Date: Wed, 17 Sep 2008 15:23:13 -0700 (PDT)
Message-Id: <20080917.152313.173231111.davem@davemloft.net>
To: paul.moore@hp.com
Cc: akpm@linux-foundation.org, sds@tycho.nsa.gov, jmorris@namei.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, ebiederm@xmission.com,
       netdev@vger.kernel.org
Subject: Re: [Bug #11500] /proc/net bug related to selinux
From: David Miller <davem@davemloft.net>
In-Reply-To: <200809171724.36269.paul.moore@hp.com>
References: <1221483926.30816.18.camel@moss-spartans.epoch.ncsc.mil>
	<20080917125053.1f9ecf37.akpm@linux-foundation.org>
	<200809171724.36269.paul.moore@hp.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>
Date: Wed, 17 Sep 2008 17:24:36 -0400

> If that is the case I'm not sure it is really that big of a deal.  Maybe 
> I'm in the minority here, but in my mind once you step away from the 
> distro supplied kernel (also applies to other packages, although those 
> are arguably less critical) you should also bear the responsibility to 
> make sure you upgrade/tweak/install whatever other bits need to be 
> fixed.

No, we tend to call this breaking things instead.
