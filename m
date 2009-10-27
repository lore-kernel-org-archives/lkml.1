Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZJ0FSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZJ0FSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 01:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZJ0FSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 01:18:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56854
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbZJ0FSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 01:18:31 -0400
Date: Mon, 26 Oct 2009 22:18:54 -0700 (PDT)
Message-Id: <20091026.221854.111712128.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: sam@ravnborg.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       nico@fluxnic.net, tony.luck@intel.com, sfr@canb.auug.org.au,
       mcgrof@gmail.com, jeff@garzik.org, robert.richter@amd.com,
       dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: David Miller <davem@davemloft.net>
In-Reply-To: <1256612558.26028.391.camel@gandalf.stny.rr.com>
References: <1256603403.26028.358.camel@gandalf.stny.rr.com>
	<20091026.183416.52095233.davem@davemloft.net>
	<1256612558.26028.391.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 26 Oct 2009 23:02:38 -0400

> Whether I'm sending a patch to Ingo, Linus, Andrew, or even you, I would
> do it publicly and have a git repo to pull from for simplicity.

Sure, but just don't do it with a GIT repo that's going to
make it's way to Linus.

When you commit to any such GIT repo, you're making a permanent
irrevocable change whose history cannot be changed.

And given what you get in return for that, it's a pretty reasonable
constraint.
