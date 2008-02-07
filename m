Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbYBGQcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbYBGQcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYBGQcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:32:14 -0500
Received: from UKEmail.nice.com ([195.166.55.162]:1150 "EHLO
	thebe.racal-recorders.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755876AbYBGQcM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:32:12 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 11:32:12 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] USB: mark USB drivers as being GPL only
Date: Thu, 7 Feb 2008 16:22:00 -0000
Message-ID: <B710AFF518DE29459D5752E7B15256D75E39D7@souexc02.eu.nice.com>
In-Reply-To: <20080207171322.40eb7c95@dilbert.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB: mark USB drivers as being GPL only
thread-index: AchppQybflfsAurMQIO5S+6ggbpMhwAAFUHw
References: <20080125180232.GA4613@kroah.com> 
    <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> 
    <47A5D895.20300@davidnewall.com> <47A6E742.80408@otello.alma.unibo.it> 
    <47A764ED.8030605@weinigel.se> <1202161091.15090.84.camel@violet> 
    <20080206213449.6614efea@weinigel.se> 
    <20080206215442.63c94cf3@dilbert.local> <47AB056E.70802@davidnewall.com> 
    <20080207150612.21ba60df@dilbert.local> 
    <47AB163C.5070107@davidnewall.com> 
    <20080207171322.40eb7c95@dilbert.local>
From: "Dave Higton" <DAVE.HIGTON@nice.com>
To: =?iso-8859-1?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       "David Newall" <davidn@davidnewall.com>
Cc: "Christer Weinigel" <christer@weinigel.se>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Diego Zuccato" <diego@otello.alma.unibo.it>,
       "Greg KH" <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org 
> [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Hans-Jürgen Koch
> Sent: 2008 February 07 16:13
> To: David Newall
> Cc: Christer Weinigel; Marcel Holtmann; Diego Zuccato; Greg 
> KH; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
> 
> Using a symbol from a library means linking to it, and that creates a
> derived work. Why should it be different when using kernel symbols?

There's an interesting parallel in the SCO vs Novell case.

Dave


*************************************************************************************************************************************************************************************************************************************************

NICE CTI Systems UK Limited ("NICE") is registered in England under company number, 3403044.  The registered office of NICE is at Tollbar Way, Hedge End, Southampton, Hampshire SO30 2ZP.

Confidentiality: This communication and any attachments are intended for the above-named persons only and may be confidential and/or legally privileged. Any opinions expressed in this communication are not necessarily those of NICE. If this communication has come to you in error you must take no action based on it, nor must you copy or show it to anyone; please delete/destroy and inform the sender by e-mail immediately.

Monitoring: NICE may monitor incoming and outgoing e-mails.

Viruses:  Although we have taken steps toward ensuring that this e-mail and attachments are free from any virus, we advise that in keeping with good computing practice the recipient should ensure they are actually virus free.

****************************************************************************************************************************************************************************************************************************************************

 

