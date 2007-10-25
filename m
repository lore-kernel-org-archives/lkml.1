Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbXJYAgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbXJYAgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 20:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbXJYAfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 20:35:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:33126 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbXJYAfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 20:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=c2H3FB7/l8RFpVszLw4ocxIWnxeVOXMaaLKAODAjOXq8eJWLNcfLsLYi0QL+P2TN+8pSimjSrtTuHVDHWKapFIH3XECS/ZSIoJfpisKhLc0h4D7CSZoUf3NQ+R+mnEDvhyYfF4wVpj4uE0DFQbTyvlOn/uRxdHQm34OrAFObnwQ=
Message-ID: <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
Date: Wed, 24 Oct 2007 17:35:47 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Chris Wright" <chrisw@sous-sol.org>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
Cc: "Casey Schaufler" <casey@schaufler-ca.com>,
       "Adrian Bunk" <bunk@kernel.org>, "Simon Arlott" <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20071025002356.GB3660@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024223124.GI30533@stusta.de>
	 <446110.89443.qm@web36608.mail.mud.yahoo.com>
	 <20071025002356.GB3660@sequoia.sous-sol.org>
X-Google-Sender-Auth: 9a127b4ff6a693de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Chris Wright <chrisw@sous-sol.org> wrote:
> * Casey Schaufler (casey@schaufler-ca.com) wrote:
> > And don't give me the old "LKML is a tough crowd" feldercarb.
> > Security modules have been much worse. Innovation, even in
> > security, is a good thing and treating people harshly, even
> > "for their own good", is an impediment to innovation.
>
> I agree that innovation is critical to the success of Linux, and security
> is not immune to that.  The trouble is that most of the security modules
> that have come forward have had some real serious shortcomings.

Key-based masterlocks are easily broken with freon, and their combo
locks are easily brute-forced in about ten minutes. Yet, I'll still
use them to lock up my bike and garage.

The idea that poor security is worse than no security is fallacious,
and not backed up by common experience.

> I do
> believe it is prudent to keep in-tree security sensitive code under
> high scrutiny because we do not want to create security holes by adding
> problematic security code.

If security code actively *adds* holes, then that's obviously a deal breaker.
