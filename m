Return-Path: <linux-kernel-owner+w=401wt.eu-S1751976AbZI1Rjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbZI1Rjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZI1Rjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:39:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZI1Rjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:39:42 -0400
From: Matthias Geissert <geissert@mathematik.tu-darmstadt.de>
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"?
Date: Mon, 28 Sep 2009 19:42:17 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31; KDE/4.3.0; i686; ; )
Cc: Tilman Schmidt <tilman@imap.cc>
References: <Pine.LNX.4.44L0.0909202152420.15304-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909202152420.15304-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909281942.17317.geissert@mathematik.tu-darmstadt.de>
X-Provags-ID: V01U2FsdGVkX1+ZfG+gBCqwUqrCwVVSfTA1qHyOVeFWNZ41paT
 /YGMyAbUVq03lYkTHhUBvohb61kFMaD5ZtDt+WjNR8G03gpaD2
 C8B2Xq8+IJIUL46pl8pkrUOOko8nmM89glhuFp8ILw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 21 September 2009 03:59:17 schrieb Alan Stern:
> On Sun, 20 Sep 2009, Greg KH wrote:
> > Yes, I missed the fact that the ipaq driver needed to pay attention to
> > this, my mistake :(
> >
> > I'm pretty much not able to write any new patches until the end of next
> > week, due to conferences I'm currently attending, so if someone wants to
> > knock up a patch to fix this before then, it would be most appreciated.
>
> Here's a patch which ought to fix the oops.  I trust it won't cause
> any existing devices to start misbehaving.  Tilman and Matthias, please
> verify that this works okay on your systems.
Sorry for the late answer but I was abroad last week. 

I tested your patch and it works for me (it still gives me ttyUSB0 and 
ttyUSB1). 


Thanks,
matthias
