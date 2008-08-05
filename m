Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbYHER6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbYHER6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYHER6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:58:25 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:24036 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754560AbYHER6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:58:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lJE4Xbnkr0PeUTC/2aOYFuvVdVk+3bmLwmOhjmif6aE0gNdbluAkIX9sNu2r9IblWBHeBH4HCW5ofUySolrE44cfSAgON38umFvXSvRQpCsHUeJ3UuposwJ96cwsywT4C2T+GTxJp7QkhYsriOMbvN3xe+jRT/oLz2DDrQWy0sY=  ;
X-YMail-OSG: gBGVwBkVM1n0Nx2q8sS9YRp9dVMkyt4RRG0uz0etxqf1Ep2ULAqihZ34GuoOAMPcKK9fUEUIshqoAhrRBicjFWWBMKRyB98tFAExdLJIGOhGBMse0FMNcsMBZ6RfvUxMS1o-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
Date: Wed, 6 Aug 2008 03:58:11 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       Greg KH <greg@kroah.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
References: <1217883616.27684.19.camel@localhost.localdomain> <20080805005415.GA10108@infradead.org> <20080805123136.0073e52f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805123136.0073e52f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808060358.11643.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 21:31, Alan Cox wrote:
> > No, I want a sane security policy in kernelsapce that doesn't look
> > at the content because doing security by content properly is equivalent
> > to solving the halting problem.  I couldn't give a rats a** about
> > windows viruses as they can't actually cause any harm on a Linux
> > machine.
>
> Go on then.. post patches.

Onus is not (or actually often is, but should not) be on reviewers
to do this. That effectively further reduces review bandwidth.

I can see why "feature" writers like the idea though. Either they
get someone to do their work for them, or negative reviews
disappear :)
