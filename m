Return-Path: <linux-kernel-owner+w=401wt.eu-S1759099AbYBOWRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbYBOWRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbYBOWQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:16:55 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:15895 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbYBOWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:16:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d0qXxTeMbEH+aza/yzJSGMLaK60evpaqylLIb4oZwtDXsZuKCJWh6VBR/Mzxviz3GULEot/gx2nal47QdbXe9eBCRvgL83fjrZPt0NxuXu4L4mM5dQ/Wu7tslS90t7sFb6MvKEtNQJRaOxFm6K+0q/nxjxqzAzxrvlIHAH/n7zI=
Message-ID: <86802c440802151416i6948fbe1lf1c7ab357ac2535e@mail.gmail.com>
Date: Fri, 15 Feb 2008 14:16:52 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440802151411k40dfc711g4965410bba11dc33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802150127.21247.yinghai.lu@sun.com>
	 <p7363wq1nk2.fsf@bingen.suse.de>
	 <86802c440802151411k40dfc711g4965410bba11dc33@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 2:11 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Fri, Feb 15, 2008 at 3:11 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  > Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
>  >  >
>  >  > [akpm@linux-foundation.org: many fixes and cleanups]
>  >  > Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>  >  > Signed-off-by: Andi Kleen <ak@suse.de>
>  >  > Tested-by: Andi Kleen <ak@suse.de>
>  >
>  >  iirc it really was
>  >  Tested-and-didnt-pass-test-by: Andi Kleen
>  >  unfortunately. I have not rechecked recently, but on the one Intel
>  >  box the original patch and the other mcfg heuristics removed didn't work.

hope this could refresh your memory:

http://lkml.org/lkml/2008/1/8/197

YH
