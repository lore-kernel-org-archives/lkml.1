Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZHaO1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZHaO1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZHaO1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:27:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:53720 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZHaO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rgYRduzr9jnnXdyuRZ/q3f4RZzPKj+mV/TfElVu7hM+YnO3QtMDRO+Mlfwzr1m9gx/
         1IJxhE7qYqRB59lVVildolmzuGA9h3ANI3E871Vb/rmjL7I3m5q+QCh8u2ngMS70dEju
         COeLJejAkcn+Ph+bBs8IB7+3G3X9T7e3BaL58=
MIME-Version: 1.0
In-Reply-To: <4A9B96A7.5040005@gmail.com>
References: <1251462337-12531-1-git-send-email-tomi.valkeinen@nokia.com>
	 <4A9B96A7.5040005@gmail.com>
Date: Mon, 31 Aug 2009 07:20:19 -0700
Message-ID: <5e088bd90908310720p290ba68dwd6106a778fd7c740@mail.gmail.com>
Subject: Re: [PATCH 00/18] OMAP: DSS2: Intro
From: Steve Sakoman <sakoman@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 2:23 AM, Artem Bityutskiy<dedekind1@gmail.com> wrote:

> We are using DSS2 in Nokia for about a year already. N900 is using this
> code, for example. Other (non-Nokia) projects are using DSS2 as well.
> The code was public for long time and was sent several times for review.
>
> In any case,
>
> Tested-by: Artem Bityutskiy <artem.bityutskiy@nokia.com>

Gumstix has also been shipping with DSS2 on their Overo product for
many months now.

Tested-by: Steve Sakoman <steve@sakoman.com>
