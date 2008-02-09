Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYBIMb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYBIMb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbYBIMbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:31:49 -0500
Received: from 1wt.eu ([62.212.114.60]:1782 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbYBIMbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:31:48 -0500
Date: Sat, 9 Feb 2008 12:40:10 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mike Galbraith <efault@gmx.de>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived threads
Message-ID: <20080209114009.GP8953@1wt.eu>
References: <20080209000456.GA21021@lixom.net> <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu> <1202554705.10287.12.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202554705.10287.12.camel@homer.simson.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 11:58:25AM +0100, Mike Galbraith wrote:
> 
> On Sat, 2008-02-09 at 09:03 +0100, Willy Tarreau wrote:
> 
> > How many CPUs do you have ?
> 
> It's a P4/HT, so 1 plus $CHUMP_CHANGE_MAYBE
> 
> > > 2.6.25-smp (git today)
> > > time 29 ms
> > > time 61 ms
> > > time 72 ms
> > 
> > These ones look rather strange. What type of workload is it ? Can you
> > publish the program for others to test it ?
> 
> It's the proglet posted in this thread.

OK sorry, I did not notice it when I first read the report.

Regards,
Willy

