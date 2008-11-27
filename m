Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYK0UwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYK0UwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 15:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYK0UwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 15:52:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:36850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYK0UwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 15:52:05 -0500
Date: Thu, 27 Nov 2008 12:53:01 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops/warning report for the week of November 26, 2008
Message-ID: <20081127125301.3cb1e282@linux.intel.com>
In-Reply-To: <20081127204714.GA25875@elte.hu>
References: <492DD792.6080302@linux.intel.com>
	<20081127115236.GE29013@elte.hu>
	<492EE087.80708@linux.intel.com>
	<20081127201836.GA16869@elte.hu>
	<20081127122800.45fc0b1a@linux.intel.com>
	<20081127204714.GA25875@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008 21:47:14 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> IIRC the problem is that vmware _does_ claim that it supports MTRRs. 

it might.
but even if they would fix that, we would still WARN (
at least we should do our side correctly...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
