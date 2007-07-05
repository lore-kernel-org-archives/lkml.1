Return-Path: <linux-kernel-owner+w=401wt.eu-S1761510AbXGEXpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510AbXGEXpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbXGEXpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:45:40 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:36714 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbXGEXpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:45:39 -0400
Message-ID: <468D828B.4060008@nortel.com>
Date: Thu, 05 Jul 2007 17:45:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ernie Petrides <petrides@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <200707052312.l65NCjfb025915@pasta.boston.redhat.com>
In-Reply-To: <200707052312.l65NCjfb025915@pasta.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jul 2007 23:45:19.0611 (UTC) FILETIME=[8BC4CCB0:01C7BF5E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ernie Petrides wrote:

> That's odd, because Thomas's patch removed two calls to clock_was_set(),
> which is a no-op when CONFIG_HIGH_RES_TIMERS is not enabled (at least in
> the 2.6.21 source tree).

I'm using a modified 2.6.10 tree...I expect the timer code is different.

Chris
