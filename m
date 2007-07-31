Return-Path: <linux-kernel-owner+w=401wt.eu-S932474AbXGaV11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbXGaV11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765980AbXGaV1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:27:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:64588 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765172AbXGaV1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:27:01 -0400
Message-ID: <fa686aa40707311426t23f23fbctc9865faf87ba7cdc@mail.gmail.com>
Date: Tue, 31 Jul 2007 15:26:55 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Greg KH" <greg@kroah.com>
Subject: Re: USB-related instability on 2.6.23-rc1
Cc: linux-usb-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stuart Hayes" <Stuart_Hayes@dell.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>
In-Reply-To: <20070731212454.GB18839@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa686aa40707311406w10169a20ibbef77c198020af8@mail.gmail.com>
	 <20070731212454.GB18839@kroah.com>
X-Google-Sender-Auth: 2ce33424d691ff02
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Greg KH <greg@kroah.com> wrote:
> On Tue, Jul 31, 2007 at 03:06:07PM -0600, Grant Likely wrote:
> > I've attached my kernel config file and a dmesg output
>
> Can you enable CONFIG_USB_DEBUG and send the linux-usb-devel list and
> us, the output when you have these problems?

Yes, I'll compile up a kernel right a way and do so.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
