Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbXKMXtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbXKMXtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbXKMXs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:48:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:14131 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbXKMXs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:48:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N0ONzq4E8f4xbh7VqYoTlPSU9AOhDQs0lifOlb+4MZ9brNRBDqtumv0W2TvqL8rXJRvCis9V2PIPEsnbiOrXSvMMk6GUmGlcjEY5tP0Xf68UFwC7C9l0OJfEr8e1Tq8aVxv2bgbS1Jhmfv4pwzsTP0HNlfBrt+/i+itM9bQ+RhA=
Message-ID: <93d1fdd10711131548q41ea3418rd8ceb04345e4f006@mail.gmail.com>
Date: Tue, 13 Nov 2007 18:48:56 -0500
From: "Ron Yorgason" <yorgasor@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Better support for Delkin cardbus CF adapters -- IDE layer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071113225722.36ed3a30@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <93d1fdd10711121003t2286493bob25a3acd12134720@mail.gmail.com>
	 <20071112194806.4cb9c688@the-village.bc.nu>
	 <93d1fdd10711131404u4bdf1d08pb3f579e370c125f0@mail.gmail.com>
	 <20071113225722.36ed3a30@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, you're right.  He gave me the name for the wrong device.  It's
really an Interfirm HS-CF32 device.  He said the company has gone out
of business, but a quick google shows an interfirm.co.jp site with
this HS-CF32 device on it.  I'll try and get specifications there.

--Ron

On Nov 13, 2007 5:57 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 13 Nov 2007 17:04:57 -0500
> "Ron Yorgason" <yorgasor@gmail.com> wrote:
>
> > I received a response from Synchrotech, the supplier of one of my
> > cards.  He said that they were under NDA with their manufacturing
> > partner and couldn't offer the full specs.  However he could tell me
> > the specific bridge chip:
> >
> > JMicron JMB368 PCIe to PATA controller
>
> Seems odd for the cardbus controller as cardbus is PCI not PCIe but would
> make sense for Expresscard devices. In theory a Jmicron plug in card
> would just work.
>
>
