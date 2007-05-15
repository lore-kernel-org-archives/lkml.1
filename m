Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbXEOTY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbXEOTY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbXEOTYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:24:20 -0400
Received: from gw.goop.org ([64.81.55.164]:35553 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbXEOTYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:24:19 -0400
Message-ID: <464A08DC.7030303@goop.org>
Date: Tue, 15 May 2007 12:24:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <Pine.LNX.4.61.0705121323030.9570@yvahk01.tjqt.qr> <20070512135143.GG85884050@sgi.com>
In-Reply-To: <20070512135143.GG85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> A patch for you to try, Jeremy. I've just started a test run on it...
>   

OK, it seems to work.  I haven't given it an overnight run, but its run
longer without failing than it did before.

    J
