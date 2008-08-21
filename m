Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbYHUPdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbYHUPdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYHUPdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:33:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:1984 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYHUPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dHr4TRW4gzadCll078k0YCkPaUHIGFgVm+uqOMbtfEkXWk7KVH3UyFXVe2WcBVOoUA
         u5HdqGDRxRVlt4UAkEJQ93gxTU2jWJntAYWTFqMwD9WW76DT/C9L1p3AeqvNJZkisUSw
         kWviuVD4LcHqxxQZ2iA0+8aaMtmzhTHnhMk6g=
Message-ID: <86802c440808210833wc3c76b5vc3a7f0d6208bf07f@mail.gmail.com>
Date: Thu, 21 Aug 2008 08:33:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>, "Vivek Goyal" <vgoyal@redhat.com>,
       "Bill Fink" <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <654003.23282.qm@web82104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <654003.23282.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 7:09 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:

>
> I will try to provide the entire output tonight or tomorrow.  It will be
> difficult, though:  it looks like I have to try to fit the info from about
> 60 of the printk's in your patch onto the 80x25 VGA screen, and still
> make it understandable enough to be useful.
>

with hpet=disable?

YH
