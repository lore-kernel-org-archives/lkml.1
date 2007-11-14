Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbXKNXCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbXKNXCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbXKNXCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:02:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbXKNXCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:02:35 -0500
Message-ID: <473B7D07.6030901@redhat.com>
Date: Wed, 14 Nov 2007 17:56:07 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
References: <20071114.031216.11725447.davem@davemloft.net> <200711141125.18568.nickpiggin@yahoo.com.au> <18235.26873.437786.651828@cargo.ozlabs.ibm.com> <200711142117.56352.nickpiggin@yahoo.com.au>
In-Reply-To: <200711142117.56352.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2007 05:17 AM, Nick Piggin wrote:
> 
> But in general, for special files, I guess the response is usually
> some structured data (that is not visible at the syscall layer).
> So I don't see a big problem to have a similarly arbitrarily
> structured request.
> 
> 

IOW, an ioctl.
