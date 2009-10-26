Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZJZXa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZJZXa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZJZXa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:30:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42990
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843AbZJZXa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:30:27 -0400
Date: Mon, 26 Oct 2009 16:30:50 -0700 (PDT)
Message-Id: <20091026.163050.156983266.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: sam@ravnborg.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       nico@fluxnic.net, tony.luck@intel.com, sfr@canb.auug.org.au,
       mcgrof@gmail.com, jeff@garzik.org, robert.richter@amd.com,
       dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: David Miller <davem@davemloft.net>
In-Reply-To: <1256599588.26028.340.camel@gandalf.stny.rr.com>
References: <20091023205400.GA8356@elte.hu>
	<20091023215958.GA4139@merkur.ravnborg.org>
	<1256599588.26028.340.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 26 Oct 2009 19:26:28 -0400

> I think this is more of a failure in git than in the work flow we
> present.

Others (like me) will say you should have let that patch cook for a
while on the mailing list or in your tree before publishing, in order
to let those acks and tested-by replies come in.

That's how I handle this.

And I really don't buy the argument that you have to publish the
change in a GIT tree to get those ACKs and tested-by replies.
