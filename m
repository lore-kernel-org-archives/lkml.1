Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbXEIWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbXEIWgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759411AbXEIWf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:35:59 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:24522 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759413AbXEIWf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ayRH/f/EZBraPoHM5LeHd9bgSvkkI4v5rZqxDF2QUO+gICQxGpbD7KNoe+py+bsL85bCRLtDtaGMM+TYa2qmVONuFKufhnbP0DGKXmg/dPzLxfPZnfKaSZjScwzZtu4oGRAOeWTQ3+1rcbi+2iAJ06KSqH5Z2ngyyFif3H7v9aE=
Message-ID: <7b69d1470705091535k87a377bi3921c68c5c3f6b2a@mail.gmail.com>
Date: Wed, 9 May 2007 17:35:57 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: [PATCH] "volatile considered harmful" document
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <25493.1178744744@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25493.1178744744@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Jonathan Corbet <corbet@lwn.net> wrote:
> OK, here's an updated version of the volatile document - as a plain text
> file this time.  It drops a new file in Documentation/, but might it be
> better as an addition to CodingStyle?
>  ...
---

I think the size of this file is OK as a separate file, but much too
big for CodingStyle. It would be good to also write a pithy paragraph
to go into CodingStyle to convey the rule and point at this file.

scott
