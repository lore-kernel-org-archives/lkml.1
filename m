Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbXGKRna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbXGKRna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXGKRnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:43:21 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:52613 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbXGKRnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:43:20 -0400
Date: Wed, 11 Jul 2007 13:41:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
Subject: Re: [Patch RT] Fix CFS load balancing for RT tasks
In-Reply-To: <1184173580.12353.105.camel@chaos>
Message-ID: <Pine.LNX.4.58.0707111341190.18766@gandalf.stny.rr.com>
References: <20070711164708.48907792@frecb000686.frec.bull.fr>
 <1184173580.12353.105.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2007-07-11 at 16:47 +0200, Sébastien Dugué wrote:
> >
> >   P.S. Thanks to Steven Rostedt for logdev which is proving invaluable in
> >        cases like this.
> >

Great to hear!!!

I'll be uploading a new version of Logdev in a week or so.

Thanks for the feedback.

-- Steve

