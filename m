Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbYGGLBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbYGGLBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYGGLB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:01:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43116
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbYGGLB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:01:27 -0400
Date: Mon, 07 Jul 2008 04:01:26 -0700 (PDT)
Message-Id: <20080707.040126.178187777.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670807070219s2dd43aaia29713f5076ecd0d@mail.gmail.com>
References: <20080620.162135.203810660.davem@davemloft.net>
	<a4423d670806201636n4f3d107bk290ed831eb5eefb4@mail.gmail.com>
	<a4423d670807070219s2dd43aaia29713f5076ecd0d@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander Beregalov" <a.beregalov@gmail.com>
Date: Mon, 7 Jul 2008 13:19:05 +0400

> Hi David
> 
> Is it possible to add some debug code to understand what is going on?

What do you want me to add?  The thing hangs and we have no idea
where since there are no messages on the console and the hang
happens before we have any kind of console output.

Why do you think I haven't been able to fix this yet?

Besides I'm too busy with some networking stuff to work at
all on this at the moment, so folks will just need to be
patient or do the grunt work of debugging this themselves.
