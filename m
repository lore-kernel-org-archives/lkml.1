Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbXE1RS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbXE1RS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXE1RSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:18:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42400 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbXE1RSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:18:50 -0400
Date: Mon, 28 May 2007 22:56:58 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Kirill Korotaev <dev@sw.ru>, Nick Piggin <nickpiggin@yahoo.com.au>,
       tingy@cs.umass.edu, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, wli@holomorphy.com, tong.n.li@intel.com,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070528172658.GA18582@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com> <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46577CA6.8000807@bigpond.net.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 10:17:42AM +1000, Peter Williams wrote:
> I don't think that ignoring cpu affinity is an option.  Setting the cpu 
> affinity of tasks is a deliberate policy action on the part of the 
> system administrator and has to be honoured.  

mmm ..but users can set cpu affinity w/o administrator priveleges ..

-- 
Regards,
vatsa
