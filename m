Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYFZJoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYFZJoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYFZJoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:44:04 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:47339 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756545AbYFZJoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:44:01 -0400
Date: Thu, 26 Jun 2008 15:13:20 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, containers@lists.osdl.org,
       mingo@elte.hu, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: A question about group CFS scheduling
Message-ID: <20080626094320.GA5326@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <ac8af0be0806260019q45fa7285oa0fc79fb02254d28@mail.gmail.com> <1214468112.2794.9.camel@twins.programming.kicks-ass.net> <ac8af0be0806260133u68a5692flab65e4bb6dcf2a13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac8af0be0806260133u68a5692flab65e4bb6dcf2a13@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 04:33:11PM +0800, Zhao Forrest wrote:
> 
> Thank you for your detailed explanation! I have one more question:
> cgrouping and USER grouping is mutual exclusive, am I right? That is,
> when enabling cgrouping, USER grouping need to be disabled, vice
> versa.
> 

Yes, you are right.

-- 
regards,
Dhaval
