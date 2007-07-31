Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbXGaXVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbXGaXVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXGaXV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:21:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:64240 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbXGaXV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:21:28 -0400
Message-ID: <fa686aa40707311621i68c67618p771e10282725cd13@mail.gmail.com>
Date: Tue, 31 Jul 2007 17:21:26 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Stuart_Hayes@dell.com" <Stuart_Hayes@dell.com>
Subject: Re: USB-related instability on 2.6.23-rc1
Cc: greg@kroah.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9B18D8C@ausx3mpc125.aus.amer.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa686aa40707311406w10169a20ibbef77c198020af8@mail.gmail.com>
	 <20070731212454.GB18839@kroah.com>
	 <DFEF91B22ED07447AB6AA4B237F913F9B18D8C@ausx3mpc125.aus.amer.dell.com>
X-Google-Sender-Auth: d00a03fe9f7e28a5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Stuart_Hayes@dell.com <Stuart_Hayes@dell.com> wrote:
> Greg KH wrote:
> > On Tue, Jul 31, 2007 at 03:06:07PM -0600, Grant Likely wrote:
> >> I've attached my kernel config file and a dmesg output
> >
> > Can you enable CONFIG_USB_DEBUG and send the linux-usb-devel list and
> > us, the output when you have these problems?
> >
> > thanks,
> >
> > greg k-h
>
> I'm actually in the process right now of attaching a patch for this
> problem (well, I hope it's a patch for the problem you're seeing) right
> now on the bugzilla (bug 8535 at bugzilla.kernel.org).  If you'd like to
> test it, that would be great.

I've tested the patch, it appears to be working now, thanks!

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
