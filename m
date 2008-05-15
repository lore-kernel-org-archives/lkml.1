Return-Path: <linux-kernel-owner+w=401wt.eu-S1764805AbYEOSGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764805AbYEOSGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYEOSFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:05:41 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40471 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbYEOSFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:05:39 -0400
Date: Thu, 15 May 2008 23:36:43 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 22/37] x86: sysfs cpu?/topology is empty in 2.6.25
	(32-bit Intel system)
Message-ID: <20080515180643.GD6787@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, jejb@kernel.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <20080513200453.064446337@mini.kroah.org> <20080513201222.GW31167@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080513201222.GW31167@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de> [2008-05-13 13:12:22]:

> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.

Hi Greg,

This fix has been included in 2.6.26-rc2 and has been tested for
correct topology information in the following system configurations:

32-bit Two socket dual core xeon 5160 processor system
32-bit Two socket quad core xeon E5450 processor system

Tested-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

