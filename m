Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYFDUnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYFDUnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYFDUnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:43:16 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:62634 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYFDUnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:43:14 -0400
X-BigFish: VPS-3(z34a4nz98dRzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4846FE3E.4020508@am.sony.com>
Date: Wed, 4 Jun 2008 13:42:38 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi> <4846E44A.1010601@am.sony.com> <20080604191522.GA18873@uranus.ravnborg.org> <4846EBAE.2000604@am.sony.com> <20080604202314.GG4189@cs181133002.pp.htv.fi>
In-Reply-To: <20080604202314.GG4189@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2008 20:43:03.0102 (UTC) FILETIME=[957C35E0:01C8C683]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> I might be wrong, but although monitoring the size makes a lot of sense
> I don't believe "fully automate the testing ... and send notifications" 
> will work.

"fully automate" was sloppy wording on my part.  "automate enough
to not be a burden to maintain" is what I should have said.

> But if CELF has resources then doing this kind of stuff IMHO makes
> more sense than adding a config option for each 5kB of code
> (and also has better long-term effects).

Good point about the better long-term effects.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

