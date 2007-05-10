Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbXEJErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbXEJErS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbXEJErJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:47:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37694 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751052AbXEJErH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:47:07 -0400
Date: Wed, 9 May 2007 21:47:06 -0700
From: Paul Jackson <pj@sgi.com>
To: balbir@linux.vnet.ibm.com
Cc: vatsa@in.ibm.com, linux-kernel@vger.kernel.org,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, rohitseth@google.com, ebiederm@xmission.com,
       mbligh@google.com, containers@lists.osdl.org, serue@us.ibm.com,
       menage@google.com, svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/9] Containers (V9): Basic container
 framework
Message-Id: <20070509214706.5b05eec5.pj@sgi.com>
In-Reply-To: <46429B13.6090402@linux.vnet.ibm.com>
References: <20070427104607.252541000@menage.corp.google.com>
	<20070427111300.015604000@menage.corp.google.com>
	<46377BA4.6030701@linux.vnet.ibm.com>
	<20070501114030.62b85494.pj@sgi.com>
	<46380901.2050001@linux.vnet.ibm.com>
	<20070501231254.4267777e.pj@sgi.com>
	<46429B13.6090402@linux.vnet.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir wrote:
> Thanks for the script. Would you like to contribute this script to
> LTP for wider availability and testing?

Sounds good - though I'm a tad lazy, and don't know how to contribute
this to the LTP.

You're welcome to contribute it yourself, if that's easier for you,
or to point me in the direction of some information on this.

Since it's GPL, you can republish it, under that license.

... Most likely however, it will take a little tweaking to make this
test work well for LTP.  Most automated test environments have some
requirements on the behaviour of each test, and it would be surprising
if this test happen already to conform to LTP's requirements.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
