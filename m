Return-Path: <linux-kernel-owner+w=401wt.eu-S1764657AbYBTFym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764657AbYBTFym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYBTFyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:54:07 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:31521 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945AbYBTFyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:54:05 -0500
X-Greylist: delayed 1963 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 00:54:05 EST
Date: Wed, 20 Feb 2008 14:21:09 +0900 (JST)
Message-Id: <20080220.142109.11595419.nemoto@toshiba-tops.co.jp>
To: hskinnemoen@atmel.com
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: atmel_spi clock polarity
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080218153158.2ff8842a@dhcp-252-066.norway.atmel.com>
References: <20080218124237.0b5f701c@dhcp-252-066.norway.atmel.com>
	<20080218.231243.41197917.anemo@mba.ocn.ne.jp>
	<20080218153158.2ff8842a@dhcp-252-066.norway.atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 15:31:58 +0100, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > Anyway, I will try your patch in a few days.
> 
> Ok, thanks. If it works, that would be great, but given your
> description above I'm not sure if I dare hope for it.

Unfortunately it did not work.  The clock state did not change by
writing MR register.

---
Atsushi Nemoto
