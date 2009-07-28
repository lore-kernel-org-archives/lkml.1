Return-Path: <linux-kernel-owner+w=401wt.eu-S1751104AbZG1H0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104AbZG1H0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZG1H0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:26:24 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:60962 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZG1H0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:26:23 -0400
X-SourceIP: 213.93.53.227
Subject: Re: CFS group scheduler fairness broken starting from 2.6.29-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ken Chen <kenchen@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20090728041425.GA3276@in.ibm.com>
References: <20090723075735.GA18878@in.ibm.com>
	 <1248696557.6987.1615.camel@twins>  <20090728041425.GA3276@in.ibm.com>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 09:28:58 +0200
Message-Id: <1248766138.6987.2763.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 09:44 +0530, Bharata B Rao wrote:

> > How does the below work?
> 
> Restores the fairness values to that of 2.6.28. IOW, works fine.

That's pretty good for a patch I merely compile tested ;-)

I'll merge this, unless someone (Ken?) can convince me there's something
wrong with it ;-)



