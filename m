Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYGCVRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYGCVRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbYGCVRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:17:22 -0400
Received: from saeurebad.de ([85.214.36.134]:56936 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbYGCVRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:17:21 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug #10741] bug in `tty: BKL pushdown'?
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	<X8mbwW6K81I.A.EyF.Q99ZIB@albercik>
Date: Thu, 03 Jul 2008 23:15:51 +0200
In-Reply-To: <X8mbwW6K81I.A.EyF.Q99ZIB@albercik> (Rafael J. Wysocki's message
	of "Sun, 29 Jun 2008 20:18:42 +0200 (CEST)")
Message-ID: <87zloy7jp4.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.

Yeah, it still exists.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
> Subject		: bug in `tty: BKL pushdown'?
> Submitter	: Johannes Weiner <hannes@saeurebad.de>
> Date		: 2008-05-18 2:16 (43 days old)
> References	: http://marc.info/?l=linux-kernel&m=121107706506181&w=4
> 		  http://lkml.org/lkml/2008/6/16/104
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>

	Hannes
