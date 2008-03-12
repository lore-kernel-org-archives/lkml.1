Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbYCLAUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbYCLAUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYCLATy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:19:54 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41958 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbYCLATx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:19:53 -0400
Date: Tue, 11 Mar 2008 17:18:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [stable] [PATCH] alloc_percpu() fails to allocate percpu data
Message-ID: <20080312001813.GS4416@sequoia.sous-sol.org>
References: <47BDBC23.10605@cosmosbay.com> <170fa0d20803111115n3e8eb438s9b1ad7fff2fb8672@mail.gmail.com> <47D6D24D.2080007@cosmosbay.com> <170fa0d20803111239u4d25b7c8p915e63a43cb389c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <170fa0d20803111239u4d25b7c8p915e63a43cb389c6@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Snitzer (snitzer@gmail.com) wrote:
> On 3/11/08, Eric Dumazet <dada1@cosmosbay.com> wrote:
> > Mike Snitzer a écrit :
> >  > I see that this fix was committed to mainline as commit
> >  > be852795e1c8d3829ddf3cb1ce806113611fa555
> >  >
> >  > The commit didn't "Cc: <stable@kernel.org>", and it doesn't appear to
> >  > be queued for 2.6.24.x.  Should it be?
> >
> > Yes, it should be queued fo 2.6.24.x
> 
> That means both of the following commits need to be cherry-picked into 2.6.24.x:
> b3242151906372f30f57feaa43b4cac96a23edb1
> be852795e1c8d3829ddf3cb1ce806113611fa555

Just send each with appropriate commit hash id and relevant Cc's to
stable@kernel.org so we can pick them up.

thanks,
-chris
