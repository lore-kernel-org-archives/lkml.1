Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834Ab0ALJAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0ALJAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828Ab0ALJAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:00:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:37694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab0ALJAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:00:41 -0500
Subject: Re: tbench regression with 2.6.33-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1263258546.3598.19.camel@minggr.sh.intel.com>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1263211680.4244.50.camel@laptop>
	 <1263226612.6290.9.camel@marge.simson.net>
	 <1263258546.3598.19.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 09:54:09 +0100
Message-ID: <1263286449.4244.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 09:09 +0800, Lin Ming wrote:
> I test this patch applied to 2.6.33-rc3, but no help on tbench
> regression. 

How stable is this regression on your machines? That is, can you bisect
it? Me and Mike seem to have no luck bisecting it, ending up at totally
unrelated patches and the like :/

