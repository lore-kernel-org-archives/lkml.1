Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYCaVWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYCaVWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbYCaVV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:21:56 -0400
Received: from lazybastard.de ([212.112.238.170]:35832 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbYCaVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:21:55 -0400
Date: Mon, 31 Mar 2008 23:21:34 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: [RFC PATCH] UBIFS - new flash file system
Message-ID: <20080331212133.GA2388@logfs.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F0EE63.3060401@nokia.com> <20080331171757.GA2077@logfs.org> <84144f020803311349w7f1b83e8x174ada25ffc85215@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020803311349w7f1b83e8x174ada25ffc85215@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 March 2008 23:49:16 +0300, Pekka Enberg wrote:
> 
> There are some of us that are interested to know why we want UBIFS in
> the mainline rather than wait for LogFS or some other variant to
> appear though.

You don't have to wait long.  I was thinking about sending a patch out
tomorrow.

And I don't believe it has to be a choice.  There is little reason
against merging both - apart from any problems found in the review.

Also, competition is a good thing.  There's nothing like a flurry of
patches following an unfavorable benchmark for one side or the other. ;)

Jörn

-- 
Fancy algorithms are slow when n is small, and n is usually small.
Fancy algorithms have big constants. Until you know that n is
frequently going to be big, don't get fancy.
-- Rob Pike
