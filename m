Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbXIRE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbXIRE6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbXIRE6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:58:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:45252 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbXIRE6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fKPvymG4wYngRVFplZZxyzOPp/QhN+vNGiPEnR/UHy5LKK07GWq6nY4497Kv4XlDLQMnR6YLADQWY6XJt4g5ShpcnSHs70uQ8u9sSA2XM+SIDT9ugs5wCJtkmfWKO/h7f2pxs2XOGX2Mzn4hBQcL4iJLo/C5FA9OEgQV8OS4PQY=
Message-ID: <6b8cef970709172158m37ef64cl4727d523b40ac656@mail.gmail.com>
Date: Tue, 18 Sep 2007 00:58:08 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: Scheduler benchmarks - a follow-up
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org
In-Reply-To: <20070918045328.GD10199@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
	 <20070917130524.GA10707@elte.hu> <20070917203607.GA20564@elte.hu>
	 <6b8cef970709172130v317a6c48h814ef5a1488f798e@mail.gmail.com>
	 <20070918045328.GD10199@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Willy Tarreau <w@1wt.eu> wrote:
> Hi Rob,
>
> On Tue, Sep 18, 2007 at 12:30:05AM -0400, Rob Hussey wrote:
> > I should have pointed out before that I don't really have a dual-core
> > system, just a P4 with Hyper-Threading (I loosely used core to refer
> > to processor).
>
> Just for reference, we call them "siblings", not "cores" on HT. I believe
> that a line "Sibling:" appears in /proc/cpuinfo BTW.

Thanks, I was searching for the right word but couldn't come up with it.
