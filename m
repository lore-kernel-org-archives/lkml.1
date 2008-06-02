Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYFBE3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYFBE3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 00:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYFBE3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 00:29:10 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:7340 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbYFBE3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 00:29:09 -0400
Date: Mon, 02 Jun 2008 13:28:56 +0900 (JST)
Message-Id: <20080602.132856.11964619.nemoto@toshiba-tops.co.jp>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.25.4
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080515150721.GA8420@kroah.com>
References: <20080515150721.GA8420@kroah.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 08:07:21 -0700, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> We (the -stable team) are announcing the release of the 2.6.25.4 kernel.
> 
> It contains a bunch of bug fixes, and one security update, so all users
> of the 2.6.25 series are encouraged to upgrade.

Could you tell me which commit contains the "security update" ?
I could not find it by reading commitlog.

Is it
"{nfnetlink, ip, ip6}_queue: fix skb_over_panic when enlarging packets"
or
"nf_conntrack: padding breaks conntrack hash on ARM"
or
"sparc: Fix SA_ONSTACK signal handling."
or yet other one?

---
Atsushi Nemoto

