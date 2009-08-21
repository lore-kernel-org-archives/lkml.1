Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZHUMT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZHUMT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 08:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZHUMTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 08:19:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52975 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbZHUMTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 08:19:25 -0400
Subject: Re: [PATCH -rt] timer: delay waking softirqs from the jiffy tick
From: Peter Zijlstra <peterz@infradead.org>
To: John Kacur <jkacur@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>, dinogun@gmail.com
In-Reply-To: <520f0cf10908210512n7e426d1es4b5b0e0d953af7c5@mail.gmail.com>
References: <1250848605.7538.16.camel@twins>
	 <520f0cf10908210512n7e426d1es4b5b0e0d953af7c5@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Aug 2009 14:19:11 +0200
Message-Id: <1250857151.7538.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 14:12 +0200, John Kacur wrote:
> On Fri, Aug 21, 2009 at 11:56 AM, Peter Zijlstra<peterz@infradead.org> wrote:

> > cpu#0, 2393.874 MHz

> cpu#0, 2792.838 MHz

Now clearly the most important information here is that your cpu is
faster than mine :-)

/me runs
