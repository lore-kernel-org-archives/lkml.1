Return-Path: <linux-kernel-owner+w=401wt.eu-S2992724AbXBISKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992724AbXBISKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 13:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992729AbXBISKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 13:10:51 -0500
Received: from favoritemo.com ([65.99.212.195]:51290 "EHLO favoritemo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992724AbXBISKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:10:50 -0500
Mime-Version: 1.0 (Apple Message framework v749.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5508A1DA-D067-4B97-A1A6-CFC791F20E2E@favoritemo.com>
Content-Transfer-Encoding: 7bit
From: Matt Mitchell <matt@favoritemo.com>
Subject: Re: [PATCH] security/keys: correct handling of key->serial collisions
Date: Fri, 9 Feb 2007 12:09:20 -0600
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.749.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following myself up...looks like David Howells already fixed this in  
a commit from Tuesday.  The patch I posted is actually a diff against  
that, which I didn't notice until now.  Whoops and nevermind.

I will pursue with appropriate folks stable backports for anyone  
running 2.6.18 or 2.6.19 in their distributions.

Thanks and apologies,

-m

On Feb 9, 2007, at 9:55 AM, Matt Mitchell wrote:

> cleanup

