Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbYECLuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbYECLuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 07:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYECLt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 07:49:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:33858 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbYECLt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 07:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VnzMk6oFO33hx9p2BW0M43JLOm414lDh3Ny+hyhDsxQhFB46aZvXDYO3D/gQjh2mjE3cclRJvxwFIIMFFKXndOnxpKCjGvXZLIHYGlk3PQBno4by/APPXsdUN+3awxvO3FPQI7PKIR2NRZ7krX37z4MRBEKpyglGh09Gfdwbc0w=
Message-ID: <ed10ee420805030449h67374410l568295093e01185@mail.gmail.com>
Date: Sat, 3 May 2008 04:49:56 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] hfsplus: Correct user visible printk
Cc: "Frans Pop" <elendil@planet.nl>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080502150439.76beaf27@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080502142925.2e439d8a@core>
	 <200805021600.42610.elendil@planet.nl> <20080502150439.76beaf27@core>
X-Google-Sender-Auth: df2ed717debc35da
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Actually using proper language is most definitely an improvement. Right
>  now we are using incorrect made up words. Not only that we are using
>  incorrect made up words when the ...

Alan, you misunderestimate[1] how important Linux has become.  Linux is
important and pervasive enough that you have the ability to make any new
word you wish, like well, "Linux".

(Although I do hope and pray that "propogate" never becomes an accepted
spelling).

>  computing professional bodies also say that our choice is wrong.

And Microsoft says deploying Linux is "risky".  Are we supposed to care?

I've changed my mind on this issue.  I think we should keep "journaled" in
the sources.  It makes sense and if future dictionaries credit the etymology of
that word to Linux kernel developers, so much the better.

-sb

[1] Inside joke on USians.
