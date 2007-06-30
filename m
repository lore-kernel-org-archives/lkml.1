Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbXF3D3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbXF3D3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbXF3D3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:29:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:61141 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbXF3D3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fcDivtwiPE5Z2sWw82SGLTV82N1VFPq/vodxAR1l9YBc84Jo52EaR7CuQRp+vgCSiTVRms56AHmyYcrMh1wpfJo2G0efn7nv3+4XrlBUJ7xJ5yuavDkERZejpCDzdmw704meX8czz9Vrt+eOH0uN8pFGcl6C8KcB5tExh/2j8uk=
Message-ID: <a781481a0706292029m31cf1295ie552bfc2707348cd@mail.gmail.com>
Date: Sat, 30 Jun 2007 08:59:00 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [RFC] automatic CC generation for patch submission
Cc: "Dan Aloni" <da-x@monatomic.org>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0706292010w4d28305eu4b9280333afd4e6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070630023451.GA21593@localdomain> <4685C549.3020602@intel.com>
	 <a781481a0706292010w4d28305eu4b9280333afd4e6b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 6/30/07, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> > [...]
> > an easier way to implement this is to add an extra field in the MAINTAINERS
> > file, something like below. All the contact info would stay the same, closely
> > where applicable and it would allow you to also specify specific files as well.

Your idea is quite different though, of course.

> Hmm, associating MAINTAINERS and source files. I remember surfing LKML
> archives one day and coming across this huge and ugly flamefest when some
> guy called Eric S. Raymond (hehe :-) suggested something like this and got
> burned.

<ugh, reads again and feels stupid>

And before _I_ get burned for being impolite / provoking something, let me
clarify that the comment above was purely in spirit of humour (bad effort,
of course).
