Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYENWYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYENWYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYENWYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:24:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45226
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbYENWYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:24:33 -0400
Date: Wed, 14 May 2008 15:24:27 -0700 (PDT)
Message-Id: <20080514.152427.153346948.davem@davemloft.net>
To: srostedt@redhat.com
Cc: mingo@elte.hu, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: sparc64: Add ftrace support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <482B6075.4030904@redhat.com>
References: <482AE9E2.6040801@redhat.com>
	<20080514.142932.95610533.davem@davemloft.net>
	<482B6075.4030904@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>
Date: Wed, 14 May 2008 17:58:13 -0400

> It would be nice to have something like
> 
> CFLAGS_REMOVE_foo.o = -pg
> 
> Perhaps that is possible to do. Then the above "Makefile turd" wont be 
> so crappy.

That would be much nicer.
