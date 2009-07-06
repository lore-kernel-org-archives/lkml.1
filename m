Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZGFJ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZGFJ2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZGFJ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:28:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39418 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZGFJ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:28:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jeff Arnold <jbarnold@ksplice.com>
Subject: Re: Ksplice updates for Ubuntu 9.04 Jaunty
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       tabbott@ksplice.com, wdaher@ksplice.com, andersk@ksplice.com,
       nelhage@ksplice.com, price@ksplice.com, geofft@ksplice.com
In-Reply-To: <alpine.DEB.1.10.0907022047000.26615@vinegar-pot.mit.edu>
References: <20090703084359.08E3.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907022047000.26615@vinegar-pot.mit.edu>
Message-Id: <20090706182806.0C57.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  6 Jul 2009 18:28:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 3 Jul 2009, KOSAKI Motohiro wrote:
> 
> > Afaik, Solaris and some other Unix like OS have similar rebootless
> > security update mechanism.
> 
> No system other than Ksplice makes it practical to convert kernel patches 
> into hot updates while writing little to no new code.
> 
> People have manually been making limited changes to running binaries for 
> years, but making it practical to go from kernel patches to hot updates is 
> new.

Yeah, I agree it can dramatically reduce maintainance cost :)


