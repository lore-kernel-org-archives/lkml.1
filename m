Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZECVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZECVsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZECVsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:48:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59308
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847AbZECVsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:48:04 -0400
Date: Sun, 03 May 2009 14:47:58 -0700 (PDT)
Message-Id: <20090503.144758.222061423.davem@davemloft.net>
To: stlman@poczta.fm
Cc: linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] Temporary IPv6 address asignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <49FE107A.4020406@poczta.fm>
References: <49FE107A.4020406@poczta.fm>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukasz Stelmach <stlman@poczta.fm>
Date: Sun, 03 May 2009 23:45:30 +0200

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Greetings.
> 
> I discovered recently and fixed some problems with IPv6 temporary
> address asignment. I have described the problem at
> http://bugzilla.kernel.org as bugs #13208 and #13221.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13208
> http://bugzilla.kernel.org/show_bug.cgi?id=13221
> 
> The patch is available at:
> 
> http://bugzilla.kernel.org/attachment.cgi?id=21201

Nobody is going to look at this unless you post the patch
with description and proper signoffs with netdev@vger.kernel.org
CC:'d
