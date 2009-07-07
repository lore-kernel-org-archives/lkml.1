Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZGGAHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZGGAHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZGGAGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:06:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:35730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZGGAGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:06:54 -0400
Message-ID: <4A529180.7090104@kernel.org>
Date: Mon, 06 Jul 2009 17:06:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       alexs <alex.shi@intel.com>
Subject: Re: [Bug #13690] nodes_clear cause hugepage unusable on non-NUMA
 machine
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.VeE.Z0oUKB@chimera>
In-Reply-To: <dWkuWjWDsSB.A.VeE.Z0oUKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13690
> Subject		: nodes_clear cause hugepage unusable on non-NUMA machine
> Submitter	: alexs <alex.shi@intel.com>
> Date		: 2009-07-02 01:22 (5 days old)
> 


http://lkml.org/lkml/2009/7/2/326

YH
