Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYEODx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYEODx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYEODxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:53:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:27798 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYEODxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W8jCflLTmiwqxfj8vu5AHmycCrRCi6zl6QixfX6ncAEZ/rglLZsETne4pE6QiHE1vpw9fn2z7B84Ay4u6bqW3Q8PTqthfx3Z82K72To5QM20FJ1k7OMA56M+Dj7mT1uyLjqrWQmmM41BqORxy89Dqt2jAfOKHN2RckER/7Kq9lk=
Message-ID: <a4e6962a0805142053m3268671dl6f1c4cdf632656e1@mail.gmail.com>
Date: Wed, 14 May 2008 22:53:16 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc2-mm1 (p9 build error when 9P_FS=n)
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net
In-Reply-To: <20080514200435.66f30c72.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <20080514141630.bcf8d0cd.randy.dunlap@oracle.com>
	 <a4e6962a0805141700x3565e40fieda66f8a5a0a4d7a@mail.gmail.com>
	 <20080514170543.a0130556.akpm@linux-foundation.org>
	 <a4e6962a0805141929q14b1bec6r4c152625b20eb6a@mail.gmail.com>
	 <20080514200435.66f30c72.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 10:04 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 14 May 2008 21:29:08 -0500 "Eric Van Hensbergen" <ericvh@gmail.com> wrote:
>
> Yes, -mm uses both linux-next and git-v9fs (aka #v9fs-devel)
>
> linux-next uses #for-next and afacit that was empty as of a few hours
> ago.  Nothing for 2.6.27?
>

Oh, there's stuff for 2.6.27, I'm still working on stablizing it --
but I put it on hold while I tried to clear out my bugzilla backlog.
Trying to stick to a policy of increased testing and removing bugs
before potentially introducing new ones.  It helps that there have
been several additional groups starting to use 9p and hitting corner
cases my testing didn't cover before.

       -eric
