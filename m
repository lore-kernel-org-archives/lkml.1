Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbYDKSYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbYDKSYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760100AbYDKSYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:24:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33831 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760098AbYDKSYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:24:33 -0400
Date: Fri, 11 Apr 2008 20:25:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25-rc8-git7 - section mismatches on x86
Message-ID: <20080411182501.GA32066@uranus.ravnborg.org>
References: <2da21fe50804111102y3d64e658x94c95e17fd1478e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2da21fe50804111102y3d64e658x94c95e17fd1478e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 08:02:06PM +0200, Davide Pesavento wrote:
> While compiling linux-2.6.25-rc8-git7 with
> CONFIG_DEBUG_SECTION_MISMATCH=y, I noticed the following "section
> mismatch" warnings.

Thanks for your report Davide.
We have several "Section mismatch warning" fixes queued
up in -mm and in x86.git so I expect most of the ones below
to be already fixed.
Merging is postponed until next merge window.

A similar report at -rc1 time would be good.

	Sam
