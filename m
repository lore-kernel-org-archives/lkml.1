Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbYBGGZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbYBGGZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbYBGGXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:23:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:13510 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbYBGGXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:23:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=s0PV6kYyLorS5rVXiC3GxdYyvE5kMTBxGQfPzx+n7W4aUurnPFStU5vc/h8Cu6bQwekpeu4HY2xnfhF7ufFKpVHOF+/R2x1CmCzwMQahI4rcQrH6N14CtsC+D3zyv1sJVQaIlr30fkZOYelOyDckreygsYuqCoQDZFjc8qUtJmA=
Message-ID: <84144f020802062222s78533aa6qe352d5fe7b622e20@mail.gmail.com>
Date: Thu, 7 Feb 2008 08:22:56 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christer Weinigel" <christer@weinigel.se>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Cc: "David Newall" <davidn@davidnewall.com>,
       "Marcel Holtmann" <marcel@holtmann.org>, "Greg KH" <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080206221254.5780a862@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se>
	 <20080202191930.GA19826@kroah.com> <47A5D9CD.5070001@davidnewall.com>
	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	 <47A5E67D.9040804@davidnewall.com> <1202058820.15090.60.camel@violet>
	 <courier.47A84ADB.000047C1@hawking.rebel.net.au>
	 <84144f020802050346h2c26aac4v9841dd5bc98931a0@mail.gmail.com>
	 <20080206221254.5780a862@weinigel.se>
X-Google-Sender-Auth: 8d9142f611e7ffe6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christer,

On Tue, 5 Feb 2008 13:46:08 +0200
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> > What makes you qualified to make that statement (without giving any
> > evidence)? Are you're an expert on international copyright law?

On Feb 6, 2008 11:12 PM, Christer Weinigel <christer@weinigel.se> wrote:
> Are you?  You've made some very definite statements about copyright
> law.  Things that I've been told are definitely in a gray area and not
> at all as clear cut as you and the FSF likes to say.  FSF has a very
> clear agenda, and taking what they say as the gospel is a big mistake.

I have simply stated that (1) the problem boils down to what is
derived work and what is no and (2) the developers use the
EXPORT_SYMBOL_GPL as a hint of what they think to be derived work (not
necessarily tested in court). The _logical conclusion_ of these two
simple facts is, of course, to _not use_ functions marked as
EXPORT_SYMBOL_GPL unless you're willing to test your belief in court.

Now I see you really want to argue about this but could you please do
it on some other list than the LKML? We use this list for real work
too, you know, and right now you're only contributing noise. Thanks!

                        Pekka
