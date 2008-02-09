Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYBIR3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYBIR3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYBIR3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:29:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:48654 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbYBIR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:29:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lEqlA/DT6Y0HZgKesXvvQiAaHfNlFb7CodCz38RPdB058O0/cPwFmh/HQQ2NwXc9hOE+EIxoOz0PzDc3fP7EYkDOV7jOhVa5wWMC9ttXmS3mK4ONjfyjf1bxI13BNv2ZtCd67BhPeo4upm1xRjc/9jwHAp1PoSkrIaSyJaUBoKs=
Message-ID: <84144f020802090929k6b246c13tef9f64bfbfb14c5@mail.gmail.com>
Date: Sat, 9 Feb 2008 19:29:37 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christer Weinigel" <christer@weinigel.se>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Cc: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>,
       "David Newall" <davidn@davidnewall.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Diego Zuccato" <diego@otello.alma.unibo.it>,
       "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080209175051.59715a17@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080125180232.GA4613@kroah.com> <47AB056E.70802@davidnewall.com>
	 <20080207150612.21ba60df@dilbert.local>
	 <47AB163C.5070107@davidnewall.com>
	 <20080207171322.40eb7c95@dilbert.local>
	 <47AB36D2.5050602@davidnewall.com>
	 <20080207184939.17030887@dilbert.local>
	 <20080209161322.6ccd9d4d@weinigel.se>
	 <84144f020802090741k6fe3324cu99d70f13d9fd54ec@mail.gmail.com>
	 <20080209175051.59715a17@weinigel.se>
X-Google-Sender-Auth: 0fe8548bfc10d261
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 9, 2008 6:50 PM, Christer Weinigel <christer@weinigel.se> wrote:
> A device driver isn't that hard either.  I can write a device driver
> with a hand tied behind my back, to write a good balancing tree, I'd
> have to spend a lot more time reading up on algorithms.  So "trivial" is
> a matter of background.

It doesn't matter how "hard" it was to write that code. What matters
is whether your code requires enough copyrighted aspects of the
original work to constitute as derived work. There's a huge difference
between using kmalloc and spin_lock and writing a driver that is built
on to of the full USB stack of Linux kernel, for example.
