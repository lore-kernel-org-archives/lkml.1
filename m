Return-Path: <linux-kernel-owner+w=401wt.eu-S1750755AbXB0UZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbXB0UZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbXB0UZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:25:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50364 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXB0UZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:25:20 -0500
Date: Tue, 27 Feb 2007 12:25:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: anemo@mba.ocn.ne.jp, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix section mismatch warnings
Message-Id: <20070227122506.ef8dfe58.akpm@linux-foundation.org>
In-Reply-To: <20070225205302.GA5851@uranus.ravnborg.org>
References: <20070222.005728.126762028.anemo@mba.ocn.ne.jp>
	<20070225.035315.25909736.anemo@mba.ocn.ne.jp>
	<20070224232527.GA10768@uranus.ravnborg.org>
	<20070226.004838.126574842.anemo@mba.ocn.ne.jp>
	<20070225205302.GA5851@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 25 Feb 2007 21:53:02 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> Any easy way to get cross-compile tools on ubuntu other than using Dan Kegel's
> toolset or Linux Foundation precompield versions?

Not that I know of - it's all rather non-trivial.

I have uploaded a bunch of precompiled cross-compilers for redhatty systems
to http://userweb.kernel.org/~akpm/cross-compilers whcih give decent
coverage.

(URL might be inaccurate: am typing offline)
