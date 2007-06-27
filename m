Return-Path: <linux-kernel-owner+w=401wt.eu-S1762382AbXF0QK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762382AbXF0QK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXF0QKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:10:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXF0QKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:10:16 -0400
Message-ID: <46828B6C.6010203@redhat.com>
Date: Wed, 27 Jun 2007 12:08:12 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
References: <200706271653.58870.a1426z@gawab.com> <20070627155254.GO1094@stusta.de>
In-Reply-To: <20070627155254.GO1094@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2007 11:52 AM, Adrian Bunk wrote:
> On Wed, Jun 27, 2007 at 04:53:58PM +0300, Al Boldi wrote:
>> Al Viro wrote:
>>> On Wed, Jun 27, 2007 at 11:18:36AM +0200, Zolt?n HUBERT wrote:
>>>> And as I understand it, this is (was ?) the whole point of
>>>> stable/development kernels. "We" can trust a newer stable
>>>> kernel to be a drop-in replacement for an older stable
>>>> kernel (from the same series), while development kernels
>>>> need time to stabilise with the new whizz-bang-pfouit stuff
>>>> that you all so nicely add.
>>> "Drop-in" in which sense?  That out-of-tree modules keep working?
>>> Not really...
>> Al, be reasonable.  There are many out-of-tree GPL modules that won't be 
>> accepted into mainline, never mind those that shouldn't be accepted.  But 
>> these modules do have a right to not be obsoleted by constant API changes.
> 
> "have a right" are strong words.
> Who is granting them this right?
> 
>> You are effectively inhibiting the development of an out-of-tree GPL module 
>> pool, by constantly pulling the rug under that community.
>>
>> Do you think this is fair?
> 
> Why are these modules not submitted for inclusion into the kernel?
> 

I was trying to figure that out for this one:

http://code.ximeta.com/trac-ndas

No mention of ever trying to get this upstream AFAICT... but this is
interesting:

  The linux market is limited comparing that of MS Windows.
  it is very hard for us to support the various linux distros.
  we, Ximeta, are trying to support those requests as many as
  we can, though the resources are very limited.


