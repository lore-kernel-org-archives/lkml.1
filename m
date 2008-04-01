Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbYDAW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbYDAW1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYDAW1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:27:16 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:49091 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbYDAW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:27:15 -0400
From: Chr <chunkeey@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Wed, 2 Apr 2008 00:27:12 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200804010130.17453.chunkeey@web.de> <200804012316.16371.rjw@sisk.pl>
In-Reply-To: <200804012316.16371.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804020027.13148.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX186sKyyIArQDAESAxS+8oQTKcnPIFDz0bzrxML2
	Z4VvCtjjUd7IS4zkv0jnTy3oFMtVJlMyDjl/4CrHXFl/iwwNU8
	edjdH9aWM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 23:16:15 Rafael J. Wysocki wrote:
> On Tuesday, 1 of April 2008, Chr wrote:
> > On Tuesday 01 April 2008 01:14:24 Rafael J. Wysocki wrote:
> > > On Tuesday, 1 of April 2008, Chr wrote:
> > >
> > > Have you posted the .config already?
> >
> > Done!
>
> Hmm.  Can you please choose one RTC infrastructure and maybe disable
> CONFIG_HPET_EMULATE_RTC?
>
Yep... compiling -rc8 now.

Regards,
	Chr.

