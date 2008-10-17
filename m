Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYJQKTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYJQKTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYJQKSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:18:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49791 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751039AbYJQKSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:18:53 -0400
Date: Fri, 17 Oct 2008 12:18:44 +0200
From: Pavel Machek <pavel@suse.cz>
To: raz ben yehuda <razb@bitband.com>
Cc: lenb@kernel.org, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Subject: [PATCH 1/2] linux-acpi: sos documentation
Message-ID: <20081017101844.GB10850@ucw.cz>
References: <1223941094.5437.17.camel@raz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223941094.5437.17.camel@raz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-14 01:38:13, raz ben yehuda wrote:
> From: Raz Ben Yehuda <razb@bitband.com>
> 
> Signed-off-by: Raz Ben Yehuda <razb@bitband.com>
> ---

No changelog, useful...

> diff -urpN linux-2.6.27/Documentation/SOS.txt linux-2.6.27-dbg/Documentation/SOS.txt
> --- linux-2.6.27/Documentation/SOS.txt	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.27-dbg/Documentation/SOS.txt	2008-10-14 00:29:32.000000000 +0200
> @@ -0,0 +1,14 @@
> +				SOS
> +
> +SOS is a service oriented scheduler. SOS is a method of relating one or more
> +distinct services to a processor.In other words, a core(s) is assigned to
> +a chore, not a chore to a core.
> +Technically speaking, by virtually removing a processor from the operating
> +system, using Linux ACPI facility one can bind processors to services.
> +SOS management and control is done by sosctl.
> +To fully understand what is SOS, when should it be used it and for which
> +puprose,please refer to http://sos-linux.cvs.sourceforge.net/sos-linux/sos/Documentation/.
> +

I don't think this should be acpi specific... and you should provide
real doc, not pointer to web page.

Plus select some better acronym.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
