Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYFVUPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYFVUPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYFVUP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:15:26 -0400
Received: from saeurebad.de ([85.214.36.134]:58211 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbYFVUPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:15:25 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug #10741] bug in `tty: BKL pushdown'?
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
	<4mRZUF-hVeG.A.H9F.mvpXIB@albercik>
Date: Sun, 22 Jun 2008 22:15:12 +0200
In-Reply-To: <4mRZUF-hVeG.A.H9F.mvpXIB@albercik> (Rafael J. Wysocki's message
	of "Sun, 22 Jun 2008 19:54:46 +0200 (CEST)")
Message-ID: <87tzfldy5r.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.

Yup.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
> Subject		: bug in `tty: BKL pushdown'?
> Submitter	: Johannes Weiner <hannes@saeurebad.de>
> Date		: 2008-05-18 2:16 (36 days old)
> References	: http://marc.info/?l=linux-kernel&m=121107706506181&w=4
> 		  http://lkml.org/lkml/2008/6/16/104
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>

	Hannes
