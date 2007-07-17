Return-Path: <linux-kernel-owner+w=401wt.eu-S964853AbXGQUzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853AbXGQUzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbXGQUys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:54:48 -0400
Received: from nspiron-1.llnl.gov ([128.115.41.81]:18796 "EHLO smtp.llnl.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936278AbXGQUyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:54:47 -0400
X-Greylist: delayed 717 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 16:54:47 EDT
X-Attachments: 
X-IronPort-AV: i="4.16,547,1175497200"; 
   d="scan'208"; a="30761308:sNHT2191777690"
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
From: Matt Leininger <leininger2@llnl.gov>
Reply-To: leininger2@llnl.gov
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
In-Reply-To: <adazm1urji8.fsf@cisco.com>
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
	 <adazm1urji8.fsf@cisco.com>
Content-Type: text/plain
Organization: Lawrence Livermore National Laboratory
Date: Tue, 17 Jul 2007 13:43:07 -0700
Message-Id: <1184704987.7702.106.camel@hyperion>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 11:07 -0700, Roland Dreier wrote:
> >  - Take a look at Sean's local SA caching patches.  I merged
>  >    everything else from Sean's tree, but I'm still undecided about
>  >    these.  I haven't read them carefully yet, but even aside from that
>  >    I don't have a good feeling about whether there's consensus about
>  >    this yet.  Any opinions about merging, for or against, would be
>  >    appreciated here.
> 
> Does anyone other than Sean have an opinion here?  If you want this
> feature, if you've tested it, if you don't think it's ready yet,
> whatever, please speak up -- I don't feel comfortable making a
> decision on my own here (although I will if I have to).
  
  Roland,
 
     I would like to see these features moved upstream.  DOE funded this
work as part of the items we see needing on our large scale IB
deployment (both present and future).  So from at least one big customer
perspective we see this as useful.  

    I'll let others comment on specific code/implementation issues.

  Thanks,

	- Matt

> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general

-- 
Matt Leininger, Ph.D.
Lawrence Livermore National Laboratory
leininger2@llnl.gov
V 925-422-4110
