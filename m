Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYAJXpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYAJXpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbYAJXpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:45:34 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:44406 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYAJXpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:45:34 -0500
Subject: Re: [x86] list of style offenders
From: Daniel Walker <dwalker@mvista.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4d8e3fd30801101540l264068f1i2475f53d6ea11f70@mail.gmail.com>
References: <1199995391.29897.26.camel@imap.mvista.com>
	 <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
	 <1200006481.29897.48.camel@imap.mvista.com>
	 <4d8e3fd30801101540l264068f1i2475f53d6ea11f70@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 15:43:52 -0800
Message-Id: <1200008632.29897.51.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 00:40 +0100, Paolo Ciarrocchi wrote:
> On Jan 11, 2008 12:08 AM, Daniel Walker <dwalker@mvista.com> wrote:
> 
> > The git logs also show that arch/x86/math-emu/fpu_trig.c hasn't been
> > modified since it was pull in on Oct. 11 ..
> 
> Daniel,
> are we looking at the same tree?
> fpu_trig.c has been modified (and cleaned up) by Ingo 35 hours ago:
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=history;f=arch/x86/math-emu/fpu_trig.c;h=ecd06680581c51cbb7631cd0240708e92d9ef919;hb=mm

Not it's appears we aren't .. The tree I was using was a straight pull
of the repository above .. I guess there's a separate repository, and
branch for x86 ..

Daniel

