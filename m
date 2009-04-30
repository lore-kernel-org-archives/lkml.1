Return-Path: <linux-kernel-owner+w=401wt.eu-S1764272AbZD3QwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764272AbZD3QwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763003AbZD3Qvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:51:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35826
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760379AbZD3Qvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:51:52 -0400
Date: Thu, 30 Apr 2009 09:51:47 -0700 (PDT)
Message-Id: <20090430.095147.208962142.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-arch@vger.kernel.org, monstr@monstr.eu,
       remis.developer@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/27] asm-generic: add generic versions of common
 headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <200904301849.45543.arnd@arndb.de>
References: <265d330107973ffda3b4b8a3c26ec93f31dfdf00.1241105648.git.arnd@arndb.de>
	<20090430.094129.39981996.davem@davemloft.net>
	<200904301849.45543.arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 30 Apr 2009 18:49:44 +0200

> On Thursday 30 April 2009, David Miller wrote:
>> Many sites are bouncing because the date on your emails is
>> as much as two days in the past.
> 
> Any suggestions on which tool I should use? I've been burned by
> both 'quilt mail' and 'git-format-patch' this week and don't want
> to make any more experiments. I looked at git-send-email, but
> I'm sure I'd screw up even more with that because it directly
> sends out the patches rather than giving me an mbox file to look
> at.

I use "git format-patch" and send the postings by hand.

I don't trust automated tools to actually send the thing out, because
as postmaster I've seen them screw up in so many monumental ways.
