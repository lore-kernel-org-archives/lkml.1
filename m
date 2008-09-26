Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYIZXCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYIZXCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYIZXB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:01:58 -0400
Received: from mail.atheros.com ([12.36.123.2]:54869 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbYIZXB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:01:57 -0400
Date: Fri, 26 Sep 2008 16:01:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Release of Atheros 802.11abg HAL under the ISC
Message-ID: <20080926230149.GE5972@tesla>
References: <20080926215701.GC5972@tesla> <48DD687E.5060703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48DD687E.5060703@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 03:55:58PM -0700, Maxim Levitsky wrote:
> If I understand this correctly, madwifi is no longer a non-free driver?

MadWifi is based on a proprietary HAL which is slightly different
than this one, so no, its still non-free. The "free" drivers where
I think focus should be put in is ath5k and ath9k as they are now both
merged as part of the Linux kernel.

  Luis
