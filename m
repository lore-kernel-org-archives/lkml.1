Return-Path: <linux-kernel-owner+w=401wt.eu-S1765457AbXFRSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765457AbXFRSlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764010AbXFRSlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:41:13 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:19834 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762073AbXFRSlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:41:12 -0400
Date: Mon, 18 Jun 2007 13:41:09 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070618184109.GA1210728@hiwaay.net>
References: <fa.toMqQ3LqoQn6Xh51bVordO8WMVc@ifi.uio.no> <fa.S7TtURxpneesx5OvHH3PsGMA/6I@ifi.uio.no> <fa.FCPGQxJuO8s/Srp6aUwojWeKBWQ@ifi.uio.no> <fa.CT3b+p3Ki2+O+ri7hJPZXsp4NLI@ifi.uio.no> <fa.odGxpxwBnim1al2UmlWzWtOzvQA@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181122410.12717@asgard.lang.hm>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time,  <david@lang.hm> said:
>do you realize that redhat uses checksums or signatures to check the 
>validity of their CD's?
>
>try to burn a redhat image with the -pad option which adds a chunk of 0's 
>to the end of the image and try to boot it.

It'll boot and run just fine.  The checksum is simply an optional
integrity check (you can bypass it by choosing "Skip" when it prompts to
test your CD/DVD).

>I seriously doubt if redhat tells you how to how to generate such a 
>checksum/signature.

You are seriously wrong then.  The tool is in the anaconda package, and
there are docs on using it both there and many places on the web.
