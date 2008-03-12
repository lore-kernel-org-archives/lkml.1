Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYCLOro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYCLOro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYCLOrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:47:35 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:37391 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751346AbYCLOre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:47:34 -0400
Date: Wed, 12 Mar 2008 20:17:20 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH 02/17] sched: allow the CFS group scheduler to have
	multiple levels
Message-ID: <20080312144720.GD5264@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080309170850.256853000@chello.nl> <20080309170926.096086000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309170926.096086000@chello.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2008 at 06:08:52PM +0100, Peter Zijlstra wrote:
> This patch makes the group scheduler multi hierarchy aware.
> 

Just a heads up, my system is hanging when I try to add tasks to groups
till this patch applied. Debugging now.

thanks,
-- 
regards,
Dhaval
