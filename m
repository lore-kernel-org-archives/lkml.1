Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbYFVHDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbYFVHDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 03:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYFVHDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 03:03:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55258
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbYFVHDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 03:03:11 -0400
Date: Sun, 22 Jun 2008 00:03:10 -0700 (PDT)
Message-Id: <20080622.000310.82491017.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806211542050.21474@engineering.redhat.com>
References: <20080620.144128.32005196.davem@davemloft.net>
	<20080620.215139.218732028.davem@davemloft.net>
	<Pine.LNX.4.64.0806211542050.21474@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sat, 21 Jun 2008 15:42:56 -0400 (EDT)

> For me it doesn't work. Locked up after "console: colour dummy device 
> 80x25".

Machine type, compiler, and config please so I can debug this :-)
