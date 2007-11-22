Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXKVSsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXKVSsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXKVSsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:48:10 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:61135 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXKVSsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PuKVUZx2E0TbyM+m/WLV6sbPO79epp2JanxKugBqIeC6ZOgSvLJVmcjdWn08o0RqxsvmiyKlsOcUOvMSV7QTY0i/xA48xX4mPwStMx7O8tKMlVkMIzOrt55ViRZNcUGSZ+IgD5Qa9wwOJcLDSkTsGFnq6uNOBHC57TYWZSIjjdA=
Message-ID: <cfd18e0f0711221048k538d05abk8e4303d5f90a6e1b@mail.gmail.com>
Date: Thu, 22 Nov 2007 19:48:07 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: Where is the new timerfd?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711220933330.7256@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com>
	 <Pine.LNX.4.64.0711220933330.7256@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 22, 2007 6:34 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Thu, 22 Nov 2007, Michael Kerrisk wrote:
>
> > Hey Davide,
> >
> > Where is the new timerfd API.  In 2.6.24-rc3, I see the *old* API...
>
> Maybe Andrew stuffed the turkey with it? :) It was there. I remeber it was
> merged. Some screw up reverted it?

t looks that way.
