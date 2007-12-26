Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbXLZKj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbXLZKj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 05:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbXLZKju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 05:39:50 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:59781 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751481AbXLZKjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 05:39:49 -0500
Date: Wed, 26 Dec 2007 16:09:44 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@in.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: Circular locking dependency
Message-ID: <20071226103944.GA6980@skywalker>
References: <20071224112842.GA8347@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071224112842.GA8347@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2007 at 04:58:42PM +0530, Dhaval Giani wrote:
> Hi,
> 
> Just hit this on sched-devel. (not sure how to reproduce it yet, can't
> try now. I believe i can hit it on mainline as well as there is nothing
> scheduler specific).
> 


http://bugzilla.kernel.org/show_bug.cgi?id=9483

-aneesh

