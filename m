Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbXGKWG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbXGKWG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763923AbXGKWGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:06:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:58003 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761957AbXGKWGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:06:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fi80TY9ZIJXahTrJAP7wT9niXSpfEZ+lSl00+G6Y2kTFWzq9WQ0chwcxzfEVS2mMsSEB3WFowTSldJfsgDurgDuiJk7vwkrG+dIE2evRYsAe2svDkks0fH0GVqlEk0dSPhtRlKRH2iL0HV0nFmq2gYhvW5cH6jS/VVOcCSGNkBw=
Message-ID: <86802c440707111506q522f3f1dra242c8fa6a8f8b2d@mail.gmail.com>
Date: Wed, 11 Jul 2007 15:06:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>, "Yinghai Lu" <Yinghai.Lu@sun.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Greg KH" <greg@kroah.com>, rientjes@google.com,
       "Christoph Lameter" <clameter@sgi.com>,
       "David Miller" <davem@davemloft.net>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] more about numa_node with struct device
In-Reply-To: <20070711094034.GC19061@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707101652.20613.yinghai.lu@sun.com>
	 <20070711094034.GC19061@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jul 10, 2007 at 04:52:19PM -0700, Yinghai Lu wrote:
> > these are revised or new patch with numa_node in struct device in addition to
>
> Do you have a pointer to a background posting why you want all this?

http://lkml.org/lkml/2007/6/29/246
http://lkml.org/lkml/2007/7/10/492
