Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZLXMNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZLXMNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZLXMNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:13:11 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53390 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZLXMNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:13:10 -0500
Date: Thu, 24 Dec 2009 13:13:09 +0100
From: Andreas Mohr <andi@lisas.de>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: [PATCH 2/5] USB: ftdi_sio: fix latency-timeout endianess bug
Message-ID: <20091224121309.GA30228@rhlx01.hs-esslingen.de>
References: <1261654931-31543-1-git-send-email-jhovold@gmail.com> <1261654931-31543-3-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261654931-31543-3-git-send-email-jhovold@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 24, 2009 at 12:42:08PM +0100, Johan Hovold wrote:
> Also fixes DMA transfer to stack for latency buffer.

Good stuff, I'd say. I had planned to submit exactly the same thing
(URB buffer stack thing, and endianness fixes).

Andreas Mohr
