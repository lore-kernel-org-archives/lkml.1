Return-Path: <linux-kernel-owner+w=401wt.eu-S934825AbXEHJrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825AbXEHJrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934818AbXEHJrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:47:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:20585 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934816AbXEHJrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QJ87cMRFDtOlCfgojKS5JAv9VGuq5yZKb7ks521B5WmYWKhhg7I9Va9lPJQ2PPbXIIXXFggMWlPkVnT6GFZiP7pDo03ce0TJY+OmJ1QbVH9Sw2Z33YY5Qqxk6yKdiYGGurN3vXbDHRLwYgHZotXaIvGGjG3ATLSHZ1uJhP5wMiE=
Message-ID: <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>
Date: Tue, 8 May 2007 12:47:34 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6 (was Re: Please pull 'libertas' branch of wireless-2.6)
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "Dan Williams" <dcbw@redhat.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-wireless@vger.kernel.org,
       marcelo@kvack.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <463F443A.5000306@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org>
	 <20070303052140.GA31075@infradead.org>
	 <20070507104117.GA31601@infradead.org>
	 <1178539423.3032.24.camel@localhost.localdomain>
	 <20070507141143.GB5125@tuxdriver.com> <463F443A.5000306@garzik.org>
X-Google-Sender-Auth: 1b5633cb3c02ad51
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Jeff Garzik <jeff@garzik.org> wrote:
> Open source is about release early, release often.  Not "hide code in a
> dark corner until Christoph thinks it is perfect."  We have high
> standards for upstream merged code, but that standard is not perfection.

Please. This has nothing to do with Christoph. (1) the driver seems to
break every Linux coding style convention known to man and (2) adds a
new ABI with bunch of ioctls() that apparently haven't been reviewed
properly. That's just not acceptable for mainline kernel!

                               Pekka
