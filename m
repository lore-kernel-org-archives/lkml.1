Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZAERFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZAERFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAERFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:05:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbZAERFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:05:00 -0500
Date: Mon, 5 Jan 2009 12:04:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/2] tracing/ftrace: provide the base infrastructure for
 stat tracing
In-Reply-To: <c62985530901050857q4d1a04kf9a5078477fef4bc@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901051203150.27085@gandalf.stny.rr.com>
References: <4956aff1.0405560a.0eb9.ffffd126@mx.google.com>  <alpine.DEB.1.10.0901051047030.27085@gandalf.stny.rr.com> <c62985530901050857q4d1a04kf9a5078477fef4bc@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 Jan 2009, Fr?d?ric Weisbecker wrote:
> 
> So I don't know how it will be better to fix what you pointed out
> here. By making a delta patch on top of the current one and rebasing
> the next one, or by making a delta on top of the next one...?
> Ingo, what would you prefer?
> 

This is a critical bug, I would make it a separate patch and then Ingo can 
get it in right away.

Thanks,

-- Steve

