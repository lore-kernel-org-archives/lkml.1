Return-Path: <linux-kernel-owner+w=401wt.eu-S1762293AbYJJQ5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293AbYJJQ5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:57:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbYJJQ4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:56:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759171AbYJJQ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:56:48 -0400
Date: Fri, 10 Oct 2008 12:56:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Anders Kaseorg <andersk@MIT.EDU>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Make ftrace_test_p6nop disassembler-friendly
In-Reply-To: <48EF7EE7.6040409@zytor.com>
Message-ID: <alpine.DEB.1.10.0810101256000.21101@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0810092209460.21569@vinegar-pot.mit.edu> <20081010085429.GB319@elte.hu> <alpine.DEB.1.10.0810100927110.26408@gandalf.stny.rr.com> <48EF7EE7.6040409@zytor.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 10 Oct 2008, H. Peter Anvin wrote:
> 
> The (semi-)amusing thing is that it should never, ever, get there.
> 66 66 66 66 90 is used over this, which should always work.

Yeah, that was me being overly paranoid ;-) Which is not always a bad 
thing.

-- Steve

