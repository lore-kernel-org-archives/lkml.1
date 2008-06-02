Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYFBIOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYFBIOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYFBIOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:14:05 -0400
Received: from saeurebad.de ([85.214.36.134]:53219 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbYFBIOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:14:04 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug #10741] bug in `tty: BKL pushdown'?
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	<UJSav77TyUB.A.llE.zrZQIB@albercik>
Date: Mon, 02 Jun 2008 10:13:23 +0200
In-Reply-To: <UJSav77TyUB.A.llE.zrZQIB@albercik> (Rafael J. Wysocki's message
	of "Sat, 31 May 2008 19:48:05 +0200 (CEST)")
Message-ID: <878wxotfto.fsf@saeurebad.de>
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
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
> Subject		: bug in `tty: BKL pushdown'?
> Submitter	: Johannes Weiner <hannes@saeurebad.de>
> Date		: 2008-05-18 2:16 (14 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121107706506181&amp;w=4
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>

Bug still exists in Linus' current tree.

	Hannes
