Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZALFML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZALFML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 00:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZALFL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 00:11:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41321 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZALFLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:11:55 -0500
Message-ID: <496AD0E9.2020909@zytor.com>
Date: Sun, 11 Jan 2009 21:11:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Mark A. Miller" <mark@mirell.org>
CC: Bernd Petrovitsch <bernd@firmix.at>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net>	 <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>	 <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>	 <20090104030619.GA21466@linux-sh.org>	 <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>	 <1231677939.3517.5.camel@gimli.at.home> <31014a580901111936q41486efagcb90af2b6880a470@mail.gmail.com>
In-Reply-To: <31014a580901111936q41486efagcb90af2b6880a470@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark A. Miller wrote:
> 
> Actually, something that has amused me during this discussion, is that
> right now, the latest stable Perl (5.8.8) does not compile correctly
> on a uclibc host...
>

The latest stable Perl is 5.10.0, and the latest of the 5.8 series is 5.8.9.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

