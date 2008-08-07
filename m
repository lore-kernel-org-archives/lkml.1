Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYHGMnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYHGMnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYHGMm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:42:56 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43815 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbYHGMmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:42:55 -0400
Date: Thu, 7 Aug 2008 14:42:43 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, gerg@uclinux.org
Subject: Re: [2.6.28 parch] the scheduled SERIAL_COLDFIRE removal
Message-ID: <20080807124243.GA3037@Chamillionaire.breakpoint.cc>
References: <20080806211929.GB1702@cs181140183.pp.htv.fi> <20080807123446.26ed37c3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080807123446.26ed37c3@lxorguk.ukuu.org.uk>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox | 2008-08-07 12:34:46 [+0100]:

>On Thu, 7 Aug 2008 00:19:29 +0300
>Adrian Bunk <bunk@kernel.org> wrote:
>
>> This patch contains the scheduled removal of the obsolete 
>> SERIAL_COLDFIRE driver.
>
>Added to the ttydev tree

I CCed Greg, the m68knommu maintainer, so he knows what is going on :)

Sebastian
