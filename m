Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbYDAVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbYDAVQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYDAVQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:16:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYDAVQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:16:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chr <chunkeey@web.de>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Tue, 1 Apr 2008 23:16:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200804010114.25810.rjw@sisk.pl> <200804010130.17453.chunkeey@web.de>
In-Reply-To: <200804010130.17453.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804012316.16371.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of April 2008, Chr wrote:
> On Tuesday 01 April 2008 01:14:24 Rafael J. Wysocki wrote:
> > On Tuesday, 1 of April 2008, Chr wrote:
> >
> > Have you posted the .config already?
> Done!

Hmm.  Can you please choose one RTC infrastructure and maybe disable
CONFIG_HPET_EMULATE_RTC?

Rafael
