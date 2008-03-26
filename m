Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbYCZHqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbYCZHqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYCZHpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:45:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:29910 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYCZHps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xaoelm6sgsjaPSBx2lW/RNF4XruA0BayIhzKGhVYw5InbrZ2UdJsXN8KHaYRL0OxMPaBBwYB/PhcMXK8dUysLemTIMnhM4tikFfDa1rLUuD0l8xPMsZ4WiR9nYu36OnkrR5M61j9wOzOylLcSIpDuI2jaQctz484OPFEg4OIIdE=
Message-ID: <e2e108260803260045q37792686l80ddb421f2e67c6f@mail.gmail.com>
Date: Wed, 26 Mar 2008 08:45:46 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: quicklists confuse meminfo
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080321144517.GA1545@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
	 <20080309114640.85c9c3eb.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com>
	 <200803111507.20870.nickpiggin@yahoo.com.au>
	 <e2e108260803210552i4cdef6a5qf8f5076eaac2cf03@mail.gmail.com>
	 <20080321144517.GA1545@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 3:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Bart Van Assche <bart.vanassche@gmail.com> wrote:
>
>  > Is anyone currently working on this
>  > (http://bugzilla.kernel.org/show_bug.cgi?id=9991) ? I think this
>  > should either be fixed or documented as a known issue.
>
>  it should be fixed in latest -git (by commit 985a34bd75cc8c9) - can you
>  still see it?

This issue is indeed fixed now, thanks (retested with kernel version
2.6.25-rc6-00333-ga4083c9-dirty). Where can I find the patch that
fixed this issue ? A Google query for the commit ID returned only one
result, and that was an URL that pointed to your e-mail.

Bart.
