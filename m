Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYCLJ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYCLJ34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYCLJ3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:29:45 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:57719 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYCLJ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:29:44 -0400
Subject: Re: [RFC/PATCH 03/17] sched: rt-group: full hierarchy support for
	the rt groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <661de9470803120129l66497656o948c13c6c0c26766@mail.gmail.com>
References: <20080309170850.256853000@chello.nl>
	 <20080309170926.354453000@chello.nl>
	 <20080312082532.GB3784@linux.vnet.ibm.com>
	 <661de9470803120129l66497656o948c13c6c0c26766@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 10:29:36 +0100
Message-Id: <1205314176.8514.219.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 13:59 +0530, Balbir Singh wrote:
> On Wed, Mar 12, 2008 at 1:55 PM, Dhaval Giani
> <dhaval@linux.vnet.ibm.com> wrote:
>         On Sun, Mar 09, 2008 at 06:08:53PM +0100, Peter Zijlstra
>         wrote:
>         > Update the -rt bits to support the full hierarchy support
>         started by Dhaval.
>         >
>         
>         
>         Thanks for the effort. Just a very minor comment. I will try
>         these out
>         and give more feedback.
>         
>         
>         > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>         
> 
> Shouldn't this have Dhaval's signed-off-by as well? Dhaval do you want
> to sign-off on these patches?

He can Ack it, but the 3rd patch was not authored by him.

That said, we should probably clean up the first 3 patches and fold
stuff.

