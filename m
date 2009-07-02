Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZGBXv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZGBXv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZGBXvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:51:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48240 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZGBXvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:51:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jeff Arnold <jbarnold@ksplice.com>
Subject: Re: Ksplice updates for Ubuntu 9.04 Jaunty
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       tabbott@ksplice.com, wdaher@ksplice.com, andersk@ksplice.com,
       nelhage@ksplice.com, price@ksplice.com, geofft@ksplice.com
In-Reply-To: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu>
Message-Id: <20090703084359.08E3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  3 Jul 2009 08:51:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
> 
> The Ksplice team [1] is now providing rebootless kernel updates for Ubuntu 
> 9.04 Jaunty to anyone who configures their machine to receive them [2].  
> In short, users can click a few buttons and start getting all of the 
> Ubuntu kernel security updates applied to their system without rebooting.  
> No initial kernel changes are needed.

Great.

> 
> [1] http://www.ksplice.com
> [2] http://www.ksplice.com/uptrack
> 
> I first mentioned Ksplice to the LKML in April 2008 [3], and since then 
> we've submitted several rounds of Ksplice patches [4,5,6].  So far we've 
> gotten various improvements related to Ksplice merged into mainline.
> 
> [3] http://lkml.org/lkml/2008/4/23/330
> [4] http://lkml.org/lkml/2008/9/13/6
> [5] http://lkml.org/lkml/2008/11/21/484
> [6] http://lkml.org/lkml/2008/12/5/330
> 
> Ksplice applies traditional source code patches to unmodified Linux 
> kernels.  It can be used to apply all of the Linux security patches over 
> multiple years [7], and it can also apply reliability patches and other 
> bug fixes, such as from the Linux stable tree.

Afaik, Solaris and some other Unix like OS have similar rebootless
security update mechanism.

Yes, I like linux has such feature too.


> 
> [7] http://www.ksplice.com/paper
> 
> - Jeff



