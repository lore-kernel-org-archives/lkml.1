Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZDGJOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZDGJOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZDGJLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:11:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38164 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbZDGJLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:11:16 -0400
Date: Tue, 7 Apr 2009 11:13:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Brice Goglin <Brice.Goglin@inria.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
Message-ID: <20090407091326.GN17934@one.firstfloor.org>
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com> <49DAF003.1070605@inria.fr> <20090407070530.GJ17934@one.firstfloor.org> <alpine.DEB.2.00.0904070035570.20262@chino.kir.corp.google.com> <20090407075908.GL17934@one.firstfloor.org> <alpine.DEB.2.00.0904070058070.20262@chino.kir.corp.google.com> <20090407082342.GM17934@one.firstfloor.org> <alpine.DEB.2.00.0904070123100.24412@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904070123100.24412@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I do think that it would be helpful to add a parameter to disable parsing 
> the SLIT, however, when it is known to be incorrect.  I haven't heard your 
> objection to that yet.

Then you would get 10/20 reported (the scheduler/VM need those). Would that 
help user space? I have some doubts.

The broken Opteron BIOSes report 10/20 anyways iirc.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
