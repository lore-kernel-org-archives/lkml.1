Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYKZJGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYKZJGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYKZJGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:06:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59306
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbYKZJGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:06:32 -0500
Date: Wed, 26 Nov 2008 01:06:31 -0800 (PST)
Message-Id: <20081126.010631.209875059.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/32] fix the section noise in sparc head.S
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1L3wOq-0006X2-KM@ZenIV.linux.org.uk>
References: <E1L3wOq-0006X2-KM@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:36:04 +0000

> 
> usual .text.head trick
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied.
