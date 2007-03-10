Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXCJI23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXCJI23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbXCJI22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:28:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51035
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932962AbXCJI2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:28:24 -0500
Date: Sat, 10 Mar 2007 00:28:22 -0800 (PST)
Message-Id: <20070310.002822.106265002.davem@davemloft.net>
To: compudj@krystal.dyndns.org
Cc: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH] Fix atomicity of TIF update in flush_thread() for
 sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070310080844.GA23144@Krystal>
References: <20070310080844.GA23144@Krystal>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Date: Sat, 10 Mar 2007 03:08:44 -0500

> Fix atomicity of TIF update in flush_thread() for sparc64

Applied, thanks for fixing this up.
