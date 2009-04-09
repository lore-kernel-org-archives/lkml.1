Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZDIBu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZDIBu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 21:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZDIBuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 21:50:10 -0400
Received: from blaine.gmane.org ([80.91.229.8]:42657 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZDIBuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 21:50:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
Date: Thu, 9 Apr 2009 09:36:57 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: public-alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@hugh.gmane.org,
       Larry Finger 
	<public-Larry.Finger-tQ5ms3gMjBLk1uMJSBkQmQ@hugh.gmane.org>,
       Rusty Russell 
	<public-rusty-8n+1lVoiYb80n/F98K4Iww@hugh.gmane.org>,
       Arjan van de Ven 
	<public-arjan-VuQAYsv1563Yd54FQh9/CA@hugh.gmane.org>,
       LKML <public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       "Rafael J. Wysocki" <public-rjw-KKrjLPT3xs0@hugh.gmane.org>,
       wireless 
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
References: <49DC2DF5.3010603@lwfinger.net> <9b2b86520904081006m6e6b5276v834c3565b0f6f4c7@mail.gmail.com> <m2fxgi6hdq.fsf@igel.home>
In-Reply-To: <m2fxgi6hdq.fsf@igel.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904090936.58255.rusty@rustcorp.com.au>
X-TMDA-Confirmed: Thu, 09 Apr 2009 03:49:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thursday 09 April 2009 05:35:21 Andreas Schwab wrote:
> 
> Alan Jenkins <sourcejedi.lkml-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> writes:
> 
> > I agree that commit looks like it should be a no-op though :-).
> 
> But it isn't.

How embarrassing.

Applied,
Rusty.


