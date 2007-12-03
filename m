Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbXLCQ5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbXLCQ5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXLCQ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:57:48 -0500
Received: from kai.krose.org ([140.186.190.96]:51046 "EHLO mail.krose.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXLCQ5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:57:47 -0500
Message-ID: <47543589.3050904@krose.org>
Date: Mon, 03 Dec 2007 11:57:45 -0500
From: Kyle Rose <krose@krose.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OOPS at mm/rmap.c:628
References: <47542108.1050104@krose.org> <20071203081243.0a8ad658@laptopd505.fenrus.org>
In-Reply-To: <20071203081243.0a8ad658@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thank you for your report.
> there have been several reports (at least 8 on lkml already) of this
> BUG() before for 2.6.22 (and a few before that), however nobody has
> reported this in 2.6.23 or later, so it's very likely something that
> this got fixed since in a later kernel....
>   
Outstanding.  That's what I like to hear.  (I love it when a plan comes
together?)  I anxiously await an Ubuntu 2.6.23-based kernel image. :-)

Kyle

