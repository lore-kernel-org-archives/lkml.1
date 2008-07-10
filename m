Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYGJNmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYGJNmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbYGJNmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:42:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:41095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbYGJNl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:41:58 -0400
Date: Thu, 10 Jul 2008 15:42:00 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kyle McMartin <kyle@parisc-linux.org>, linux-parisc@vger.kernel.org
Subject: Re: [Bug #10786] parisc: 64bit SMP does not boot on J5600
Message-ID: <20080710134159.GA4331@ska.dandreoli.com>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Kyle McMartin <kyle@parisc-linux.org>, linux-parisc@vger.kernel.org
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.C4C.s1LcIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uBi7uNfg81L.A.C4C.s1LcIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 01:45:52PM +0200, Rafael J. Wysocki wrote:
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.

I am going to check it later. Last time I saw it was around 2.6.26-rc7/8.

Anyway the error message was not the same firstly reported there,
it could be another problem. More details will follow. Thank you.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10786
> Subject		: parisc: 64bit SMP does not boot on J5600
> Submitter	: Domenico Andreoli <cavokz@gmail.com>
> Date		: 2008-05-22 16:14 (46 days old)
> References	: http://marc.info/?l=linux-kernel&m=121147328028081&w=4

ciao,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
