Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYEENaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYEENaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbYEEN34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:29:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44562 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbYEEN3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:29:55 -0400
Message-ID: <481F0BCD.8020306@firstfloor.org>
Date: Mon, 05 May 2008 15:29:49 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, sandeen@sandeen.net
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
 II
References: <20080502091806.GA26062@basil.nowhere.org> <20080502094543.GA11114@basil.nowhere.org> <alpine.LFD.1.10.0805051135530.3318@apollo.tec.linutronix.de> <481EDEC5.10000@firstfloor.org> <alpine.LFD.1.10.0805051434200.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805051434200.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Err, it checks the process stack when 4KSTACKS=n

Ok then please add the two changes if you feel strongly about that
(to the latest version I sent).

You always edit my patches anyways (usually driving me crazy when I have
dependent patches because nothing applies anymore when all the variables
got renamed like you often do) so I don't see any reason why you can't
do that here.

-Andi
