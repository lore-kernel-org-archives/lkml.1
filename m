Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbXIRExo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbXIRExo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbXIRExh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:53:37 -0400
Received: from 1wt.eu ([62.212.114.60]:2542 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbXIRExg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:53:36 -0400
Date: Tue, 18 Sep 2007 06:53:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: Rob Hussey <robjhussey@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org
Subject: Re: Scheduler benchmarks - a follow-up
Message-ID: <20070918045328.GD10199@1wt.eu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com> <20070917130524.GA10707@elte.hu> <20070917203607.GA20564@elte.hu> <6b8cef970709172130v317a6c48h814ef5a1488f798e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b8cef970709172130v317a6c48h814ef5a1488f798e@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Tue, Sep 18, 2007 at 12:30:05AM -0400, Rob Hussey wrote:
> I should have pointed out before that I don't really have a dual-core
> system, just a P4 with Hyper-Threading (I loosely used core to refer
> to processor).

Just for reference, we call them "siblings", not "cores" on HT. I believe
that a line "Sibling:" appears in /proc/cpuinfo BTW.

Regards,
Willy

