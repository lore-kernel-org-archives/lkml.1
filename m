Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZAJXbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZAJXbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZAJXbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:31:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:45344 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZAJXbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:31:38 -0500
Subject: Re: [Patch 0/3] Overview, OProfile SPU event profiling support for
 IBM Cell processor
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Carl Love <cel@us.ibm.com>
Cc: Robert Richter <robert.richter@amd.com>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
In-Reply-To: <1231460791.6621.54.camel@carll-linux-desktop>
References: <1228177106.6509.285.camel@carll-linux-desktop>
	 <20090108154835.GQ15411@erda.amd.com>
	 <1231460791.6621.54.camel@carll-linux-desktop>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 10:31:09 +1100
Message-Id: <1231630269.2142.91.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 16:26 -0800, Carl Love wrote:
> I pulled down the git tree, compiled and installed it.  I tested it
> against the OProfile testsuite, which includes SPU event profiling
> tests.  Everything passed.  The patch I submitted was against a 2.6.26
> tree.  You are now on a 2.6.28 tree so perhaps that is why the patch did
> not apply cleanly.  The patch has been out there for some time.  

When you submited it on Dec 2, it should have been against whatever was
the latest upstream at the time, not 2.6.26.

Cheers,
Ben.


