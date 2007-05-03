Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbXECHH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbXECHH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXECHH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:07:29 -0400
Received: from gw.goop.org ([64.81.55.164]:42902 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbXECHH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:07:28 -0400
Message-ID: <46398A31.6040701@goop.org>
Date: Thu, 03 May 2007 00:07:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: fix suspend/resume with dynamically allocated irq
 stacks
References: <20070503054809.GF26598@holomorphy.com> <46397AA1.8090606@goop.org> <20070503061233.GG26598@holomorphy.com>
In-Reply-To: <20070503061233.GG26598@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
> I had the same question about yours and just brute-force merged. Not a
> big deal for me to rediff against whatever everyone's working off of.
>   

I picked up one version of your patches you posted a couple of days ago,
but I guess you've posted the series multiple times, presumably with
differences.

How about posting the series again and I can test it out?

    J
