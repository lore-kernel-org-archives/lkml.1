Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYAPAlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYAPAlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYAPAlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:41:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46585 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYAPAlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:41:07 -0500
Date: Wed, 16 Jan 2008 01:44:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: lfence fix
Message-ID: <20080116004411.GA7005@one.firstfloor.org>
References: <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115010534.GA24854@one.firstfloor.org> <478C0D18.5020505@goop.org> <20080115013858.GA25112@one.firstfloor.org> <20080115210321.GA14757@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115210321.GA14757@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 10:03:21PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > I just tested x86.git and then x86.git + patch you send (+ build fixes 
> > in both cases), none of your patchkits. If you want me to test some 
> > other patchkit please point me to it.
> > 
> > The problem happens with plain git-x86 (+ build fixes) and also with 
> > git-x86 + your patch.
> 
> i was held up from debugging your problem by a bug introduced by you 
> into x86.git ;-) See the fix below.

Thanks.

-Andi

