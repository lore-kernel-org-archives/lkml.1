Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYERSaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYERSaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYERSaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:30:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47004 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYERSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:30:11 -0400
Subject: Re: [Bug #10616] Horrendous Audio Stutter - current git
From: Peter Zijlstra <peterz@infradead.org>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <82e4877d0805181115q422c435dv51cc853e9db9ace5@mail.gmail.com>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.81B.-tBMIB@albercik>
	 <1211131287.6463.8.camel@lappy.programming.kicks-ass.net>
	 <82e4877d0805181115q422c435dv51cc853e9db9ace5@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 18 May 2008 20:30:05 +0200
Message-Id: <1211135406.6463.10.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-18 at 14:15 -0400, Parag Warudkar wrote:
> On Sun, May 18, 2008 at 1:21 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Could people test this:
> >
> > git://git.kernel.org/home/peterz/git/linux-2.6-sched.git/ v2.6.26-rc2-group-load-balance
> 
> Is that URL right? Quits with remote hung up unexpectedly.

Sigh, I'm a moron...

try:

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git v2.6.26-rc2-group-load-balance

