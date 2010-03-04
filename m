Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0CDWx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:53:28 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:6426 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab0CDWx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:53:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jrP38alXLKfzsrlwAv0JhjA2PjOmLFgDlhiD26uLCF3bCTLYLiLmcv/5I4s2CWkZJm
         FFSTlErfO9GJRMvuJ8baCfIjLgVfZDqr0h/asiFVB6qgKh/+m4hA9gfk/9uK/h1dBzBn
         WfcYyClKRFko4r5+C0z20KtD4gaV8b0EqsLZk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1003041335540.3144@bogon.housecafe.de>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
	 <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de>
	 <dda83e781002232131i53b59c8eu7192257fc4e4f3e0@mail.gmail.com>
	 <alpine.DEB.2.01.1002232249440.28195@bogon.housecafe.de>
	 <dda83e781003031900x3ca243d9kba1df3a8b0e04105@mail.gmail.com>
	 <alpine.DEB.2.01.1003041335540.3144@bogon.housecafe.de>
Date: Thu, 4 Mar 2010 14:53:24 -0800
Message-ID: <dda83e781003041453q365896c1y3d12f3b49f3387b7@mail.gmail.com>
Subject: Re: reiserfs issue with 2.6.32.8
From: Bret Towe <magnade@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org, rjw@sisk.pl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 1:37 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Wed, 3 Mar 2010 at 19:00, Bret Towe wrote:
>> well the hardware update ended up changing more than I thought it would
>> now on 32bit from 64bit so config is completely new also for the kernel
>> end result tho is I'm on a 2.6.33 kernel and no issues
>
> If there are still no issues after some time, maybe we can then close the
> bugzilla ticket?
>
> http://bugzilla.kernel.org/show_bug.cgi?id=15309

how long would you consider 'some time'?
