Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbZGOUYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbZGOUYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbZGOUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:24:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbZGOUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:24:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=kabHBFOWhes3PiykS7Wy+4eKNmEU+SrF95jRdK86lngawb2WKHA7DAY3YEDgFUAMF
	A/FBIXyl7ED1P0P6uDTkQ==
Date: Wed, 15 Jul 2009 13:24:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephan von Krawczynski <skraw@ithnet.com>
cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: What to do with this message (2.6.30.1) ?
In-Reply-To: <20090715113740.334309dd.skraw@ithnet.com>
Message-ID: <alpine.DEB.2.00.0907151323170.22582@chino.kir.corp.google.com>
References: <20090713134621.124aa18e.skraw@ithnet.com> <4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com> <alpine.DEB.2.00.0907132247001.8784@chino.kir.corp.google.com> <20090715084754.36ff73bf.skraw@ithnet.com> <alpine.DEB.2.00.0907150115190.14393@chino.kir.corp.google.com>
 <20090715113740.334309dd.skraw@ithnet.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Stephan von Krawczynski wrote:

> > If you have some additional time, it would also be helpful to get a 
> > bisection of when the problem started occurring (it appears to be sometime 
> > between 2.6.29 and 2.6.30).
> 
> Do you know what version should definitely be not affected? I can check one
> kernel version per day, can you name a list which versions to check out? 
> 

To my knowledge, this issue was never reported on 2.6.29, so that should 
be a sane starting point.
