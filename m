Return-Path: <linux-kernel-owner+w=401wt.eu-S965408AbXBFUMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965408AbXBFUMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965423AbXBFUMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:12:17 -0500
Received: from mga06.intel.com ([134.134.136.21]:31441 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965408AbXBFUMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:12:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,291,1167638400"; 
   d="scan'208"; a="193484942:sNHT18191376"
Message-ID: <45C8E112.9070701@linux.intel.com>
Date: Tue, 06 Feb 2007 21:12:02 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
CC: Marc Donner <donner@dbd-breitband.de>, linux-kernel@vger.kernel.org
Subject: Re: cpu load balancing problem on smp
References: <200702061832.17771.donner@dbd-breitband.de> <1170785364.7324.31.camel@laptopd505.fenrus.org> <200702061941.32907.donner@dbd-breitband.de> <45C8CC2A.90403@linux.intel.com> <45C8DD9E.7010309@fliagreco.com.ar>
In-Reply-To: <45C8DD9E.7010309@fliagreco.com.ar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pablo Sebastian Greco wrote:

> 2296:        427        426        436  134563009   PCI-MSI-edge      eth1
> 2297:        252        252  135926471        257   PCI-MSI-edge      eth0

this suggests that  cores would be busy rather than only one....
