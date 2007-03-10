Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbXCJI2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbXCJI2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933062AbXCJI2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:28:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51039
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932975AbXCJI2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:28:35 -0500
Date: Sat, 10 Mar 2007 00:28:33 -0800 (PST)
Message-Id: <20070310.002833.126763148.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Fix sparc TIF_USEDFPU flag atomicity
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070310081743.GC23144@Krystal>
References: <20070310081743.GC23144@Krystal>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Sat, 10 Mar 2007 03:17:43 -0500

> Fix sparc TIF_USEDFPU flag atomicity

Also applied, thanks again.
