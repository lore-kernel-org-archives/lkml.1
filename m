Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXEITEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXEITEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbXEITES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:04:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:31466 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbXEITER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jyTZXuyzJNo4BV+gGsFoNucD2WR//B7Pn2qNc1un74r/tREtZaBpXKQIRHO3AqRGycXCXuXdUPefOin3jX+nuH0uUz78W3SAvQTfKGYN1sIrlNIzuWD9HsL41rGPV28emYi5gFDnmn3SOaxvLfVFcuu4tzGLSEBYRAv7Ai4dq7g=
Message-ID: <a781481a0705091204g1ff1eb4do2ac1bfb876b8b7e1@mail.gmail.com>
Date: Thu, 10 May 2007 00:34:15 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] doc: volatile considered evil
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Sokolovsky" <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       rientjes@google.com, jeremy@goop.org,
       "Jonathan Corbet" <corbet@lwn.net>
In-Reply-To: <20070509085253.5935f90f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <516386418.20070501080839@gmail.com>
	 <20070430235642.e576e917.akpm@linux-foundation.org>
	 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
	 <a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
	 <20070508163452.8b71f682.randy.dunlap@oracle.com>
	 <46418B4D.6030307@s5r6.in-berlin.de>
	 <20070509085253.5935f90f.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Wed, 09 May 2007 10:50:21 +0200 Stefan Richter wrote:
>
> > Randy Dunlap wrote:
> > > Add information on the problems with the C-language "volatile" keyword
> > > and why it should not be used (most of the time).
> >
> > I like Jonathan's article http://lwn.net/Articles/233479/ a lot.
> > It puts as much emphasis on the DOs as on the DON'Ts, which I find helpful.
>
> Yep.  I expect to drop my patch in favor of Jon's writeup.

Yeah, that article was both comprehensive and to-the-point indeed. I
was trying my hand at re-organizing your original mail, but Jon's
version is nicer.
