Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbXFVDYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbXFVDYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 23:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXFVDX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 23:23:56 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:8747 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXFVDXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 23:23:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iTx1k8KjBDzfWEM4q7S+86TohUZbtjQJofus+XTvcnK2FC7Xqx1J//Dq/HPH5sPYGwbSNRHTTM7o4vakTwNnCATdPXc/MVsXYkH+/oYu77ega3KY6J2+CmZR218xb/84RtQKtJ/rrU6rpAkBs+ogWM/oRLpqlfaqEpO9xxI3WOM=
Message-ID: <a8e1da0706212023k5acfbf83g2a11c36720d775cf@mail.gmail.com>
Date: Fri, 22 Jun 2007 03:23:54 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Cc: "Li Yang" <leoli@freescale.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, "TripleX Chung" <xxx.phy@gmail.com>,
       "Maggie Chen" <chenqi@beyondsoft.com>, torvalds@transmeta.com
In-Reply-To: <200706212248.34128.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1182436817579-git-send-email-leoli@freescale.com>
	 <200706212248.34128.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
2007/6/22, Rob Landley <rob@landley.net>:
> On Thursday 21 June 2007 10:40:17 Li Yang wrote:
> > This is a Chinese translated version of Documentation/HOWTO.  Currently
> > Chinese involvement in Linux kernel is very low, especially comparing to
> > its largest population base.  Language could be the main obstacle.  Hope
> > this document will help more Chinese to contribute to Linux kernel.
>
> I'm putting together a kernel documentation directory at http://kernel.org/doc
> and I could easily add translations in there.  I just don't know if this is a
> good idea.
>

I think it's not a good idea to merge translations into kernel.

> The problem is, the submission of patches happens on the various kernel.org
> mailing lists, which are all in English.  Kernel development is done in a
> single common language: English.  (If you'd like to argue for it to be done
> in another language, please make the proposal in Linus's native Swedish.)
>

Yes, I agree with you, and there's so many other languages, It's
better for someone to  create a standalone kdoc translation project
than to merge them into kernel.

Regards
dave
