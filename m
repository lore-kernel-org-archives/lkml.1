Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbXG2APX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbXG2APX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 20:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbXG2APL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 20:15:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:61378 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbXG2APJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 20:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=F6eDVESSpmN2tBNKSl2YKVsma89Wvz6RgICrJGDhDdrS9UtUglP3rzEBymNE1yX8RJMEXaUV9EC5gmfM8R0JO0WPefn+ERpiPzATjXn5+dI/jdQv2elajLfbMau/tvgs9MrNYVdI8sglJQb5Xblh7LxE0LVzRFTQuyKjbSVJIkI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/3] 2.6.23-rc1: known regressions v2
Date: Sun, 29 Jul 2007 02:13:31 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Eric Sesterhenn <snakebyte@gmx.de>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, linux-ide@vger.kernel.org,
       dth <dth@dth.net>, Netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Thomas Meyer <thomas@m3y3r.de>,
       Florian Lohoff <flo@rfc822.org>
References: <46AA581D.6080100@googlemail.com> <46AA5B39.2010209@googlemail.com>
In-Reply-To: <46AA5B39.2010209@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707290213.32294.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007, Michal Piotrowski wrote:

> IDE
> 
> Subject         : ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
> References      : http://lkml.org/lkml/2007/7/27/298
> Last known good : ?
> Submitter       : dth <dth@dth.net>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

No IDE changes after 2.6.22-git17.

Despite this I will try to follow this bugreport.

Thanks,
Bart
