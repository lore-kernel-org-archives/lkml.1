Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbXHNQNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbXHNQNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXHNQMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:12:54 -0400
Received: from smtp121.sbc.mail.re3.yahoo.com ([66.196.96.94]:44185 "HELO
	smtp121.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750814AbXHNQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:12:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=pD35zGi7A+YAMf+DKfpezLhnt6FN9qMZbIzQyoR0DlFw7XqB+rTv/DaseSIHjUeL4avjTWmHZwkVPTW36s8sJAncUFaEupmv5s6c6vuUrrkq179tRHEheu1aL7pQP6D3iWlXrV7NaXzVf+JjqkOvzLY6PhPcDcCInk79QxdQ+MU=  ;
X-YMail-OSG: EMtirXMVM1nAh2riFIGFMAmQEY0oqECBNhMtBRN8OJjcjoYAsmmPbb7JRQvwtEzta7eyrYf_Ig--
Date: Tue, 14 Aug 2007 09:12:51 -0700
From: David Brownell <david-b@pacbell.net>
To: webmaster@dragonslave.de
Subject: Re: EHCI Regression in 2.6.23-rc2
Cc: Stuart_Hayes@dell.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, jikos@jikos.cz, greg@kroah.com
References: <200708101045.57166.dex@dragonslave.de>
 <200708141146.43215.webmaster@dragonslave.de>
 <20070814154237.DF0FB2350CA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <200708141757.24787.webmaster@dragonslave.de>
In-Reply-To: <200708141757.24787.webmaster@dragonslave.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070814161251.1E91923513A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think 8237 was about where they forked off the the VT6212 as
> > their first discrete EHCI (for addon cards) claiming EHCI 1.0
> > conformance.  Too bad they didn't recycle all the VT6202 chips
> > in their inventory at that time...
>
> No hardware producer would have done that ;)

As I said:  too bad.  ;)


> > Now ... are you reporting that this worked with Stuart's patch?
> > Or that it didn't?  Or that you couldn't say?
>
> As I started this thread because Stuart's patch freezes my whole system (at 
> least my bitsect did blame him), I therefore report that it doesnt work for 
> me.

The original patch, yes.  ISTR seeing an update come around though.
Maybe I was imagining things.

