Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbZC3U4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbZC3U4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760236AbZC3U4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:56:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:3797 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbZC3U4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D0ytDVB+OekFtweo9xlCMqW5R9gV3rs4pZPj/rqAcosKopIKd4YDWwIujAlU9Ffxup
         rHmuGvKsy+GkQAB5DV3iUj+gTwLXW5hlMxzrzquPltTEFJUKZXfvaFUxHUk5wan0J6VW
         utH2gSr6wv9D16moP6TL3Pxr2x/XjA6NHRZSY=
Date: Mon, 30 Mar 2009 16:55:53 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roel Kluin <roel.kluin@gmail.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hvc_console: prevent wrapping in hvc_console_print()
Message-ID: <20090330205553.GA19278@yoda.jdub.homelinux.org>
References: <49BF956B.9030109@gmail.com> <20090330133531.f5d99c09.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330133531.f5d99c09.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 01:35:31PM -0700, Andrew Morton wrote:
>Guys, could we have a MAINTAINERS entry for this driver please?

To my knowledge, there isn't one.  Would be Ben now by default I
guess.  The previous developers have disclaimed ownership for a
while from what I remember.

josh
