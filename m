Return-Path: <linux-kernel-owner+w=401wt.eu-S934287AbYEBLjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbYEBLjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbYEBLjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:39:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52811 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbYEBLjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:39:39 -0400
Subject: Re: Horrendous Audio Stutter - current git
From: Peter Zijlstra <peterz@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200805021337.10809.elendil@planet.nl>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209724553.13978.143.camel@twins> <1209726499.13978.146.camel@twins>
	 <200805021337.10809.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 02 May 2008 13:39:32 +0200
Message-Id: <1209728372.13978.147.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 13:37 +0200, Frans Pop wrote:
> On Friday 02 May 2008, Peter Zijlstra wrote:
> > > Ok, that's _WAY_ too big, something went seriously wrong. Thanks!
> >
> > In fact, that is exactly 1024 time too large.
> >
> > How does this work for you:
> 
> Changes nothing. Values of bonus_max are unchanged and still skips.

Humm, I saw some bonus_max spikes on my laptop which were fixed by that
patchlet, ah well, the hunt goes on.

Thanks!

