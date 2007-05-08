Return-Path: <linux-kernel-owner+w=401wt.eu-S968539AbXEHWnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968539AbXEHWnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968521AbXEHWn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:43:27 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:21043 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S968526AbXEHWn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:43:26 -0400
X-YMail-OSG: _fAWlvIVM1knTy2STD.rkM40tlLtrQTpm5KP0nymp45Z5RpnVc0zp_xg4rr6Qh7MQydxrP6dXw--
Date: Tue, 8 May 2007 15:43:22 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86-64] Add getcpu and epoll_pwait system calls.
Message-ID: <20070508224322.GA8272@tuatara.stupidest.org>
References: <20070508185145.B9A8E1827261@tuatara.stupidest.org> <20070508221348.GC17482@one.firstfloor.org> <20070508221656.GA6850@tuatara.stupidest.org> <20070508222432.GA15029@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508222432.GA15029@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:24:32AM +0200, Andi Kleen wrote:

> Somehow yes.  But i'm not going to add a useless syscall just to
> shut it up.

It turns out this has come up in other places.  Sam has a suggestion
on how to silence this per-arch so I'll post a patch once that change
is in.
