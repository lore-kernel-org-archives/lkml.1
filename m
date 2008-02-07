Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbYBGNbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbYBGNbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYBGNbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:31:36 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34818 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYBGNbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:31:35 -0500
Message-ID: <47AB0834.7000201@davidnewall.com>
Date: Fri, 08 Feb 2008 00:01:32 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christer Weinigel <christer@weinigel.se>,
       Marcel Holtmann <marcel@holtmann.org>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	 <20080202123710.42df1aa0@weinigel.se>	 <20080202191930.GA19826@kroah.com> <47A5D9CD.5070001@davidnewall.com>	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>	 <47A5E67D.9040804@davidnewall.com> <1202058820.15090.60.camel@violet>	 <courier.47A84ADB.000047C1@hawking.rebel.net.au>	 <84144f020802050346h2c26aac4v9841dd5bc98931a0@mail.gmail.com>	 <20080206221254.5780a862@weinigel.se> <84144f020802062222s78533aa6qe352d5fe7b622e20@mail.gmail.com>
In-Reply-To: <84144f020802062222s78533aa6qe352d5fe7b622e20@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> I have simply stated that (1) the problem boils down to what is
> derived work and what is no and (2) the developers use the
> EXPORT_SYMBOL_GPL as a hint of what they think to be derived work (not
> necessarily tested in court). The _logical conclusion_ of these two
> simple facts is, of course, to _not use_ functions marked as
> EXPORT_SYMBOL_GPL unless you're willing to test your belief in court.
>
> Now I see you really want to argue about this but could you please do
> it on some other list than the LKML? We use this list for real work
> too, you know, and right now you're only contributing noise. Thanks!
This *is* real work.  You have blinded yourself to the fact that this
discussion is preliminary to a proposed change.

Or put another way, if you want to kill the discussion then the answer
to "shall we" is "no."
