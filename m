Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbZFKMAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbZFKMAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757729AbZFKMA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:00:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50444
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501AbZFKMA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:00:28 -0400
Date: Thu, 11 Jun 2009 05:00:30 -0700 (PDT)
Message-Id: <20090611.050030.169859977.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090611114911.GL795@n2100.arm.linux.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk>
	<20090611.042226.28424489.davem@davemloft.net>
	<20090611114911.GL795@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Thu, 11 Jun 2009 12:49:12 +0100

> I can not keep up with the number of patches that need to be
> reviewed and ultimately merged.  I know this, and I freely admit it,
> and I have done so on many occasions.

Then split up the responsibilities to other people instead of being
the choke point.  Controlling everything isn't so important.

Or, alternatively, experiment with tools that could potentially make
you more efficient (patchwork has worked wonders for me).

Anything other than simply leaving things as they are...
