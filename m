Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZAFUCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZAFUCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbZAFUC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:02:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35395
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbZAFUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:02:29 -0500
Date: Tue, 06 Jan 2009 12:02:30 -0800 (PST)
Message-Id: <20090106.120230.105229393.davem@davemloft.net>
To: sam@ravnborg.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, srostedt@redhat.com,
       mingo@elte.hu, sparclinux@vger.kernel.org
Subject: Re: ftrace breaks sparc64 build
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090106195206.GA16880@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0901061342570.10871@gandalf.stny.rr.com>
	<20090106.110114.103656110.davem@davemloft.net>
	<20090106195206.GA16880@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 6 Jan 2009 20:52:06 +0100

> The patch to unaligned_64.c is just an ugly hack.
> The patch in viohs.c makes it easier to read IMO.
> The patch to init_64.c is likewise a nice cleanup.
> 
> I will re-review and submit the latter two as proper patches.
> I see no way to refactor unaligned_64.c so it keep
> current behaviour and is equal readable.

Ok.
