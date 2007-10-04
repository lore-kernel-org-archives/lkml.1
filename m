Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbXJDSIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbXJDSIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbXJDSIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:08:48 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11876 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbXJDSIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:08:47 -0400
Date: Thu, 4 Oct 2007 20:10:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Don Mullis <dwm@meer.net>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004181017.GG5711@kernel.dk>
References: <1191478262.21598.5.camel@dmullis-laptop> <20071003231659.f41df5ed.akpm@linux-foundation.org> <20071004072515.GC5236@kernel.dk> <1191514780.30871.1.camel@dmullis-laptop> <20071004183555.3e0ed9eb@poseidon.drzeus.cx> <20071004164225.GF5711@kernel.dk> <1191517589.27856.5.camel@dmullis-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191517589.27856.5.camel@dmullis-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04 2007, Don Mullis wrote:
> That patch boots without complaint as well.
> 
> BTW, the earlier failure messages did not make it
> into /var/log/messages, only the dmesg buffer.
> This is with standard Ubuntu Gutsy logging levels.

Super, thanks for retesting!

-- 
Jens Axboe

