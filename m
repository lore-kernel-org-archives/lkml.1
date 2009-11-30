Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZK3OXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZK3OXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZK3OXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:23:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55953 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbZK3OXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:23:15 -0500
Subject: Re: Ethernet issues with lite5200 board from linux-2.6.31
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Yogesh Chaudhari <mr.yogesh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>
In-Reply-To: <d1f76ba30911300150g10c1382clb2958245ebf94362@mail.gmail.com>
References: <d1f76ba30911300038w272578dfx9adb116bde493e00@mail.gmail.com>
	 <d1f76ba30911300150g10c1382clb2958245ebf94362@mail.gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 30 Nov 2009 09:23:19 -0500
Message-Id: <1259590999.12870.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 15:20 +0530, Yogesh Chaudhari wrote:
> Hello,
>          I am running linux kernel with rt patch on embedded board
> based on lite5200 eval board. From linux-2.6.31 release, in which the
> mdio patch has gone inside,  the fec ethernet does not come up on this
> board. I get the following message at startup:
> mpc52xx MII bus: probed

Do you see the same issue without adding the rt patch?

-- Steve


