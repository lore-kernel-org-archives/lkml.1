Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbXH2AHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbXH2AHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 20:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXH2AHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 20:07:00 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:17778 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXH2AG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 20:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VFheM0Ytk5MjNLsKuo+Ema8imnM3+ba7wXuWciqyIHwRa8BDd1bIJ5znQAX0BEqSFQ7At9/XdtrvRrJicTPEwA5dw/JwCqjWCsTwrgC+n7n08H3UdPlrNgu+9oMnuCjqaNY+EuiWuHRMFiS82q9p0FSRxjxt+cd+oK/9J/pXYR4=
Message-ID: <24c800fb0708281706n6d92d9d9w7c8defc4a884296b@mail.gmail.com>
Date: Tue, 28 Aug 2007 17:06:58 -0700
From: "Pete Monroe" <pizzlemonrizzle@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Crash report 2.6.22.5
Cc: linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
In-Reply-To: <6bffcb0e0708281651g29729d6au6b40c0f9af5beed2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <24c800fb0708281140r2c46e364i77e041b6c746b60d@mail.gmail.com>
	 <6bffcb0e0708281651g29729d6au6b40c0f9af5beed2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi Pete,
>
> On 28/08/07, Pete Monroe <pizzlemonrizzle@gmail.com> wrote:
> > Hi,
> >
> > Sorry there's not more to go on here.
> >
> > A 32-bit firewall running the kernel LVS virtual server to fan out to
> > a dozen webservers ran fine for a year using  2.6.17.13, but won't
> > last more than four hours or so with 2.6.22.5.  Another server,
> > different hardware and vendor but same purpose, also crashed with
> > 2.6.22.5 after a few hours.  It had previously run 2.6.20.11.  Nothing
> > on the screen, nothing in the logs.
> >
> > I'm attaching zipped dmesg (both kernel versions),
>
> Could you capture the bug with serial/netconsole etc.?

The servers are remote, production servers and it's a PITA when they
crash.  But I'll see what I can do.  Thanks for the pointer.

--
Pete

>
> "Collecting kernel messages"
> http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf
> for more info.
