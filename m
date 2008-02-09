Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYBIReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYBIReP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYBIReA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:34:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:37061 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755105AbYBIRd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:33:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/bDhoWaAvb3iLrFUEGFTfrepIrzkqfgVzsf9J05K
	bZ0R1Ga6K6SyuM
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080209161957.GA3364@1wt.eu>
References: <20080209000456.GA21021@lixom.net>
	 <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu>
	 <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu>
	 <1202564259.4035.18.camel@homer.simson.net>  <20080209161957.GA3364@1wt.eu>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 18:33:54 +0100
Message-Id: <1202578434.10208.5.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-09 at 17:19 +0100, Willy Tarreau wrote:

> However, I fail to understand the goal of the reproducer.

(me too, I was trying to figure out what could be expected)

