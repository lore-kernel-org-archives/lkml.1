Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZJ1UNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZJ1UNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZJ1UNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:13:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524AbZJ1UNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:13:35 -0400
Date: Wed, 28 Oct 2009 13:11:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Lothar Wassmann <LW@KARO-electronics.de>, linux-usb@vger.kernel.org,
       Roland Dreier <rolandd@cisco.com>,
       Yevgeny Petrilin <yevgenyp@mellanox.co.il>, netdev@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org, linux-altix@sgi.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 1/7] bitmap: Introduce bitmap_set, bitmap_clear,
 bitmap_find_next_zero_area
Message-Id: <20091028131141.523854cb.akpm@linux-foundation.org>
In-Reply-To: <1256719397-4258-1-git-send-email-akinobu.mita@gmail.com>
References: <1256719397-4258-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Why were these patches resent?  What changed?

Everybody who is going to review these patches has already reviewed
them and now they need to review them all again?

