Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZG0RLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZG0RLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZG0RLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:11:47 -0400
Received: from outbound-mail-157.bluehost.com ([67.222.39.37]:37531 "HELO
	outbound-mail-157.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751202AbZG0RLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:11:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=d+SU7COeNF7e+VzaJpqrwIGYJCWDarx70QW6LmtdWTJwEePC9GWOSCd1R9K/J/me8LyWbyALAHhOqwJWKusOERcj0MWcBtNnWA1u56zw2PDFb9XXj6gCSAo/L7ufeEih;
Date: Mon, 27 Jul 2009 10:11:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: [Bug #13844] i915 errors
Message-ID: <20090727101143.158ef471@jbarnes-g45>
In-Reply-To: <3zAHs5O6maO.A.wXB._GObKB@chimera>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	<3zAHs5O6maO.A.wXB._GObKB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 22:28:30 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13844
> Subject		: i915 errors
> Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
> Date		: 2009-07-25 9:30 (2 days old)
> References	:
> http://marc.info/?l=linux-kernel&m=124851427612720&w=4

I probably wasn't clear enough in my last mail about this one.  The
errors have always been present, we just report them now.  I think this
particular one is harmless, but we should still try to fix it (now that
we have more data about it).

-- 
Jesse Barnes, Intel Open Source Technology Center
