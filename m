Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYJ1TRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYJ1TRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYJ1TRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:17:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbYJ1TRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:17:38 -0400
Date: Tue, 28 Oct 2008 12:17:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH] cleanup paccept
In-Reply-To: <200810281909.m9SJ9pdj003624@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.LFD.2.00.0810281216400.3386@nehalem.linux-foundation.org>
References: <200810281909.m9SJ9pdj003624@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Oct 2008, Ulrich Drepper wrote:
> 
>     sys_paccept: disable paccept() until API design is resolved

This happened because you didn't explain yourself last time eitehr.

> I don't agree with the change but I'm also tired arguing.

And this time around, Andrew asks for explanations and you're too tired.

See a pattern?

		Linus
