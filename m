Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbYLBVQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbYLBVQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYLBVQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:16:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64609 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYLBVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:16:39 -0500
Date: Tue, 2 Dec 2008 16:16:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Luis Henriques <henrix@sapo.pt>
cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
In-Reply-To: <20081202204611.GA27003@hades>
Message-ID: <alpine.DEB.1.10.0812021614470.22547@gandalf.stny.rr.com>
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com> <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com> <20081130210406.GA17952@hades> <493528D8.8010904@redhat.com> <20081202190914.GA12115@hades> <20081202194610.GA4864@hades>
 <1228249509.4886.11.camel@localhost.localdomain> <20081202204611.GA27003@hades>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 2 Dec 2008, Luis Henriques wrote:
> 
> Unfortunately, I have only my laptop (where the crash is occuring) and no
> serial port on it (I am not able to get any output from the console).  Do you
> have any suggestion on how to collect information on the crash?  I can try to
> configure Kdump to capture more info.

It is probably caused by what Avi mentioned. I guess the best you can do 
is wait for a patch from Avi and try that out.

Thanks,

-- Steve

