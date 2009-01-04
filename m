Return-Path: <linux-kernel-owner+w=401wt.eu-S1760493AbZADTI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbZADTI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760050AbZADTIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:08:07 -0500
Received: from fhw-relay07.plus.net ([212.159.14.148]:43750 "EHLO
	fhw-relay07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545AbZADTIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:08:06 -0500
Message-ID: <49610911.8000204@yahoo.com>
Date: Sun, 04 Jan 2009 19:08:01 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       =?windows-1252?Q?Martin_MOKREJ=8A?= 
	<mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <fa.b62zZFe5e154PhgA+0sdwVXD9F0@ifi.uio.no> <fa.ZTpiSvxEhp3YJDepiUQs+cU0C98@ifi.uio.no> <fa.xvvufQC6zTpU9R6vhDl51DR5V7A@ifi.uio.no> <fa.pkV69eXC76Pb9fnmERdAwXX9OKA@ifi.uio.no> <fa.hQTLXdIllf+hs4yQb092u6fowq0@ifi.uio.no>
In-Reply-To: <fa.hQTLXdIllf+hs4yQb092u6fowq0@ifi.uio.no>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 5a1c3f2a910c3250ebf048cdf20df56b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> So what's the use case where people want to be able to mount a
> filesystem needing recovery read/only without running the journal?

Corrupted SD card[1] that's been locked to read only for recovery 
purposes without having the FS tear itself apart further?

Others seem to be saying that it is useful for forensics...

[1] http://pavelmachek.livejournal.com/68701.html

