Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZEDAVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZEDAVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 20:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZEDAVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 20:21:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39231
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822AbZEDAVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 20:21:20 -0400
Date: Sun, 03 May 2009 17:21:14 -0700 (PDT)
Message-Id: <20090503.172114.26464142.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: stlman@poczta.fm, linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Temporary IPv6 address asignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1skjlrb79.fsf@fess.ebiederm.org>
References: <20090503.153428.07349534.davem@davemloft.net>
	<49FE1E71.6090500@poczta.fm>
	<m1skjlrb79.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 03 May 2009 16:58:02 -0700

> These are numbers used in the kernel sysctl binary ABI.  You just
> changed them breaking the ABI, when you put NET_IPV6_DESYNC_FACTOR in
> the middle.

In fact adding new sysctl values are totally verbotten these days.
