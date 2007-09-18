Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbXIRTMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbXIRTMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbXIRTLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:11:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:44591 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbXIRTLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NmPn+ks5rz83HkbwUbYf7AAbs0WjjekgZaWS+9Ru/pHvExeQ3CQVXRo1+Z6w77nN1Rnmenzv2W4IxWlDcMFK3fkDiWtIeLNCSolomp6wIE/Z9bmyPP3y5lu542GC8w4ah+AXzvBXf+bkLyog05VQTRS7UyJkuO+Bumn8nrEz56s=
Message-ID: <d120d5000709181211v4ab07e04y16166616ed5f0501@mail.gmail.com>
Date: Tue, 18 Sep 2007 15:11:51 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Nicolas Pitre" <nico@cam.org>
Subject: Re: [PATCH] ucb1400_ts.c -- replace an interruptible sleep with an uninterruptible one
Cc: "Rene Herman" <rene.herman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.9999.0709181338040.26525@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46EFE66A.9090400@gmail.com>
	 <alpine.LFD.0.9999.0709181203190.26525@xanadu.home>
	 <46F00AA8.4090806@gmail.com>
	 <alpine.LFD.0.9999.0709181338040.26525@xanadu.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Nicolas Pitre <nico@cam.org> wrote:
> On Tue, 18 Sep 2007, Rene Herman wrote:
>
> > On 09/18/2007 06:03 PM, Nicolas Pitre wrote:
> >
> > > On Tue, 18 Sep 2007, Rene Herman wrote:
> > >
> > > > Hi Nicolas.
> > > >
> > > > Given that it's not checking for signals, I believe this one should be an
> > > > uninterruptible sleep instead?
> > >
> > > Probably.
> >
> > Thanks. Should I send it somewhere or will you or Dmitry grab it?
>
> Please send it to Dmitry  with my ACK.
>

I have it, thanks.

Next time please use my gmail or mail.ru account -
dtor_core@ameritech.net is dead.

-- 
Dmitry
