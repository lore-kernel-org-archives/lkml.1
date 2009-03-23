Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZCWPlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZCWPlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbZCWPl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:41:27 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53310 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbZCWPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:41:26 -0400
Date: Mon, 23 Mar 2009 16:41:20 +0100
From: Daniel Mack <daniel@caiaq.de>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] lis3: SPI transport layer
Message-ID: <20090323154120.GB5393@buzzloop.caiaq.de>
References: <49AD8B0A.90901@tremplin-utc.net> <1236131099-8082-1-git-send-email-daniel@caiaq.de> <1236131099-8082-2-git-send-email-daniel@caiaq.de> <1236131099-8082-3-git-send-email-daniel@caiaq.de> <49C6CA44.5080405@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C6CA44.5080405@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 12:31:16AM +0100, Éric Piel wrote:
> Daniel Mack schreef:
> > Make use of the new abstraction layer and add a new transport layer for
> > spi. Works fine on a PXA based board.
> Tested with a HP laptop, no problem on this part.
> 
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: Eric Piel <eric.piel@tremplin-utc.net>
> Acked-by: Eric Piel <eric.piel@tremplin-utc.net>

Thanks Eric! However, I guess you wanted to ack the latest version
rather than the one you replied to ;)

Just to make sure, these are the references to the patches we want:

	http://lkml.org/lkml/2009/3/22/194
	http://lkml.org/lkml/2009/3/22/195
	http://lkml.org/lkml/2009/3/22/196

Andrew, could you add them to your tree?

Thanks,
Daniel

