Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0BKByF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 20:54:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43511
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547Ab0BKByD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 20:54:03 -0500
Date: Wed, 10 Feb 2010 17:54:13 -0800 (PST)
Message-Id: <20100210.175413.199161275.davem@davemloft.net>
To: andrew.hendry@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] X25: Fix x25_create errors for bad protocol and
 ENOBUFS
From: David Miller <davem@davemloft.net>
In-Reply-To: <d45a3acc1002061516s3b3eab26tc2a9339613684e6f@mail.gmail.com>
References: <d45a3acc1002061516s3b3eab26tc2a9339613684e6f@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: andrew hendry <andrew.hendry@gmail.com>
Date: Sun, 7 Feb 2010 10:16:59 +1100

> alloc_socket failures should return -ENOBUFS
> a bad protocol should return -EINVAL
> 
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

Both of your patches were corrupted by your email client, so they
will not apply properly.

For example, long lines were chopped up into multiple lines.

See linux/Documentation/email-clients.txt for tips.

Please fix this up and resubmit your patches.
