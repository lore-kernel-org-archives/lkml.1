Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbXGRGw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbXGRGw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXGRGwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:52:51 -0400
Received: from fwil.voltaire.com ([193.47.165.2]:53081 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751319AbXGRGwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:52:50 -0400
X-Greylist: delayed 978 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 02:52:50 EDT
Message-ID: <469DB4E1.6080200@voltaire.com>
Date: Wed, 18 Jul 2007 09:36:17 +0300
From: Or Gerlitz <ogerlitz@voltaire.com>
User-Agent: Thunderbird 1.4.1 (Windows/20051006)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: leininger2@llnl.gov, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>	<adazm1urji8.fsf@cisco.com> <1184704987.7702.106.camel@hyperion> <adatzs2pxmx.fsf@cisco.com>
In-Reply-To: <adatzs2pxmx.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2007 06:36:27.0167 (UTC) FILETIME=[F7BC22F0:01C7C905]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  >      I would like to see these features moved upstream.  DOE funded this
>  > work as part of the items we see needing on our large scale IB
>  > deployment (both present and future).  So from at least one big customer
>  > perspective we see this as useful.  
> 
> Does your reference to "present deployment" mean you are running this
> code now?

Indeed, my understanding is that the DOE uses an Open MPI device (I 
think its called PTE) which is implemented directly over libibverbs and 
hence no path queries are issued at all, if this is indeed the case, for 
them its more of a "for-the-future" thing.

Or.

