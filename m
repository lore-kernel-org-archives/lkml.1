Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbXGKJIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbXGKJIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbXGKJIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:08:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:21647 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbXGKJIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KQxrGBnX0f95QmbrS4oGYwF7EFVLjuB/Ebudi1/O00ap8Ks59o5A0FYe1PuawI77rWb+J6v/354eg0Gm5hjqqN08Aws36+Hr8cmql2LnpRckdavGYqFyzCzNSpFx5AMs2EK5kHfZE5kI6AavNIZLkdHar0rYbKoQMx1QdvDSYYk=
Message-ID: <84144f020707110208v49e6b451rea0313fe6eabde7@mail.gmail.com>
Date: Wed, 11 Jul 2007 12:08:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: revoke (Was: -mm merge plans for 2.6.23)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Christoph Hellwig" <hch@lst.de>, viro@zeniv.linux.org.uk,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20070711084253.GT21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <84144f020707110141pd8912aaw9df05d665a35d482@mail.gmail.com>
	 <20070711084253.GT21668@ftp.linux.org.uk>
X-Google-Sender-Auth: 6050b010d5c19948
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Wed, Jul 11, 2007 at 11:41:35AM +0300, Pekka Enberg wrote:
> > Well, revoke is in limbo land waiting for the VFS maintainers to take
> > a look at it...

On 7/11/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> Could you send a sanely split series against the .22 to fsdevel?

I sent the series from 2.6.22-rc6-mm1 module the ones that are
required for -mm only. I can split the core code further if you want,
but it seems bit pointless...
