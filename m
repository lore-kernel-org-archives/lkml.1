Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbXEJEth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbXEJEth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 00:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbXEJEt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 00:49:29 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41870 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXEJEt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 00:49:28 -0400
Message-ID: <4642A445.8050106@linux.vnet.ibm.com>
Date: Thu, 10 May 2007 10:19:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: vatsa@in.ibm.com, linux-kernel@vger.kernel.org,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, rohitseth@google.com, ebiederm@xmission.com,
       mbligh@google.com, containers@lists.osdl.org, serue@us.ibm.com,
       menage@google.com, svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/9] Containers (V9): Basic container framework
References: <20070427104607.252541000@menage.corp.google.com> <20070427111300.015604000@menage.corp.google.com> <46377BA4.6030701@linux.vnet.ibm.com> <20070501114030.62b85494.pj@sgi.com> <46380901.2050001@linux.vnet.ibm.com> <20070501231254.4267777e.pj@sgi.com> <46429B13.6090402@linux.vnet.ibm.com> <20070509214706.5b05eec5.pj@sgi.com>
In-Reply-To: <20070509214706.5b05eec5.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Balbir wrote:
>> Thanks for the script. Would you like to contribute this script to
>> LTP for wider availability and testing?
> 
> Sounds good - though I'm a tad lazy, and don't know how to contribute
> this to the LTP.
> 
> You're welcome to contribute it yourself, if that's easier for you,
> or to point me in the direction of some information on this.
> 
> Since it's GPL, you can republish it, under that license.
> 
> ... Most likely however, it will take a little tweaking to make this
> test work well for LTP.  Most automated test environments have some
> requirements on the behaviour of each test, and it would be surprising
> if this test happen already to conform to LTP's requirements.
> 

I'll figure out more, once I am comfortable with the script and the
setup environment, I'll try and get this into LTP with a GPL
license.


-- 
	Thanks,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
