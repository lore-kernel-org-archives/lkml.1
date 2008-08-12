Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYHLWYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYHLWYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYHLWXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:23:55 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:18502 "EHLO
	stargate.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751305AbYHLWXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:23:54 -0400
From: Divy Le Ray <divy@chelsio.com>
Organization: Chelsio Communications
To: "David Miller" <davem@davemloft.net>
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
Date: Tue, 12 Aug 2008 15:21:08 -0700
User-Agent: KMail/1.9.9
Cc: rdreier@cisco.com, rick.jones2@hp.com, jgarzik@pobox.com,
       "Steve Wise" <swise@opengridcomputing.com>,
       "Karen Xie" <kxie@chelsio.com>, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com,
       "Dimitrios Michailidis" <dm@chelsio.com>,
       "Casey Leedom" <leedom@chelsio.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <adad4kfxm9v.fsf@cisco.com> <200808121457.11356.divy@chelsio.com> <20080812.150246.42068558.davem@davemloft.net>
In-Reply-To: <20080812.150246.42068558.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121521.10101.divy@chelsio.com>
X-OriginalArrivalTime: 12 Aug 2008 22:20:54.0468 (UTC) FILETIME=[AF985040:01C8FCC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 03:02:46 pm David Miller wrote:
> From: Divy Le Ray <divy@chelsio.com>
> Date: Tue, 12 Aug 2008 14:57:09 -0700
>
> > In any case, such a stateless solution is not yet designed, whereas
> > accelerated iSCSI is available now, from us and other companies.
>
> So, WHAT?!
>
> There are TOE pieces of crap out there too.

Well, there is demand for accerated iscsi out there, which is the driving 
reason of our driver submission. 

>
> It's strictly not our problem.
>
> Like Herbert said, this is the TOE discussion all over again.
> The results will be the same, and as per our decisions wrt.
> TOE, history speaks for itself.

Herbert requested some benchmark numbers, I consequently obliged.

Cheers,
Divy



