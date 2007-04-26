Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbXDZVrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbXDZVrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbXDZVrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:47:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38378
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755167AbXDZVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:47:37 -0400
Date: Thu, 26 Apr 2007 14:47:43 -0700 (PDT)
Message-Id: <20070426.144743.94075709.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: peter.keilty@hp.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, eric.whitney@hp.com
Subject: Re: [PATCH 2/3] ia64: remove interpolater code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1177620767.6031.7.camel@localhost.localdomain>
References: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com>
	<20070426202702.23343.10036.sendpatchset@rambler.zko.hp.com>
	<1177620767.6031.7.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Thu, 26 Apr 2007 13:52:47 -0700

> This specific patch may need to be held off until Dave Miller pushes his
> SPARC64 GENERIC_TIME conversion (as SPARC64 currently uses the
> time_interpolator code). 
> 
> I think Dave intends to push it soon, so it shouldn't be a long wait.

Feel free to break the tree meanwhile in order to delete this,
I won't mind as I'll have it fixed as soon as I merge my
sparc tree to Linus.
