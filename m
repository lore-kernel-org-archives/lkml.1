Return-Path: <linux-kernel-owner+w=401wt.eu-S932654AbYCFQZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbYCFQZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759526AbYCFQZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:25:34 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:28004 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095AbYCFQZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:25:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jsO8HI8/b1jXHkOtn74oUi4eupB6u3dRMW1ql4lPDeCnsEIZZ2gAY8UJKWk+wI7QTS3Ddj/YtAeJO3RXa84wiSZGsURud1QZh3QQkn1v+18aqqF7U9HmN1dN8LsvEgsWc9xNKpJXMUc2gjJBVQzQncrJseiY7VlmCLeCgpu8jiM=
Message-ID: <5a4c581d0803060825u485185a5jbefdaa96d47fdf60@mail.gmail.com>
Date: Thu, 6 Mar 2008 17:25:28 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: ehci-hcd affects hda speed
Cc: "Rene Herman" <rene.herman@keyaccess.nl>,
       "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200803051303.46275.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr>
	 <47CEC816.6000808@keyaccess.nl>
	 <5a4c581d0803051203s1a0048c2u5f10b3eb442cfafb@mail.gmail.com>
	 <200803051303.46275.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 10:03 PM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 05 March 2008, Alessandro Suardi wrote:
>  > I reported this problem well over an year ago, and it was never fixed.
>
>  Yeah, nobody who can debug the problem has hardware that ill-behaved.

Heh :) but the box is doing fine, uptime in triple digits, bittorrenting away
 without any issue since I replaced a faulty RAM stick many moons ago...

>  It'd be great if someone could chase this down.

I'm always available to test patches - but I don't have the skill and
 knowledge to understand this much :(

--alessandro

 "We act as though comfort and luxury were the chief requirements
   of life, when all that we need to make us really happy is
   something to be enthusiastic about."

   (Charles Kingsley)
