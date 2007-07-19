Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXGSEui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXGSEui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 00:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXGSEua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 00:50:30 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:35605 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbXGSEu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 00:50:29 -0400
Date: Thu, 19 Jul 2007 10:17:08 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: System hangs on running kernbench
Message-ID: <20070719044708.GB3699@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20070718075648.GA4235@linux.vnet.ibm.com> <20070718010700.1ca7fd9f.akpm@linux-foundation.org> <20070718094142.GA12330@linux.vnet.ibm.com> <469E2CE2.3070805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E2CE2.3070805@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuck,

On Wed, Jul 18, 2007 at 11:08:18AM -0400, Chuck Ebbert wrote:
> On 07/18/2007 05:41 AM, Dhaval Giani wrote:
> > On Wed, Jul 18, 2007 at 01:07:00AM -0700, Andrew Morton wrote:
> >> On Wed, 18 Jul 2007 13:26:48 +0530 Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> >>
> Softlockup is broken in 2.6.22.
> 

The system does not hang on 2.6.22. It is however still hanging with
yesterday's git plus Ingo's softlockup patch.

-- 
regards,
Dhaval

I would like to change the world but they don't give me the source code!
