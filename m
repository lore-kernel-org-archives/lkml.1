Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbXIEP4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbXIEP4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbXIEP4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:56:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:43649 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbXIEP4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IlqUoyHo5Gfi747cpgE1Ixqlj0SXWJkvzILQ7qYmsXI1o1cxACGqv8CoPwWsYggpAIPfHv07Tuh6cLIOimqgnii8f70EIisz6Fda/7DpFNKugZmK8Uz8soiff4lMRABc/tjWFI2IN4LSlB7QGXIkl2NTzElVIW1MeNHgegCyb5E=
Message-ID: <6bffcb0e0709050856i5531bb87l1235b402e51d0556@mail.gmail.com>
Date: Wed, 5 Sep 2007 17:56:44 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: nfs4 hang regression
Cc: "Bret Towe" <magnade@gmail.com>, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com
In-Reply-To: <20070905085120.bc90ffe2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780708221541x4fabd27er64e6ecaa33ddccbf@mail.gmail.com>
	 <20070905085120.bc90ffe2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 05/09/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 22 Aug 2007 15:41:18 -0700 "Bret Towe" <magnade@gmail.com> wrote:
>
> More than two weeks, you've bisected it and there's no sign of any action?
>
> I don't see this on Michal's list so perhaps it already got fixed in a different
> thread.  Have you tested current mainline?

AFAIK it is fixed - commit 3d39c691ff486142dd9aaeac12f553f4476b7a62

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
