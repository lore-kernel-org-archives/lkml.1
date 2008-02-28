Return-Path: <linux-kernel-owner+w=401wt.eu-S1761224AbYB1WrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224AbYB1WrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761642AbYB1Wqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:46:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60593 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761254AbYB1Wqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:46:50 -0500
Message-ID: <47C739A6.5020608@zytor.com>
Date: Thu, 28 Feb 2008 14:45:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080227221033.GR17932@hjernemadsen.org> <20080228091639.GB1133@elte.hu> <20080228092846.GC17932@hjernemadsen.org> <20080228094000.GA2987@elte.hu> <20080228150444.GG17932@hjernemadsen.org> <47C6F4F9.90700@zytor.com> <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org>
In-Reply-To: <20080228194920.GJ17932@hjernemadsen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just realized something important.

Could you please send me a *complete* strace of the execution of s2ram 
from the beginning?

	-hpa

