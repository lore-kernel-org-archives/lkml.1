Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYHKRme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYHKRme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYHKRmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:42:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbYHKRmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:42:05 -0400
Date: Mon, 11 Aug 2008 10:41:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Bug #11273] 2.6.27-rc1: softcursor behaviour changed
In-Reply-To: <cX_-nNkxKaF.A.-1._CjnIB@albercik>
Message-ID: <alpine.LFD.1.10.0808111041060.3462@nehalem.linux-foundation.org>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.-1._CjnIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Aug 2008, Rafael J. Wysocki wrote:
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).

The revert is now in my tree as 3838f59fc2ea9821f3ea13adb555bfc6ea43c74c.

		Linus
