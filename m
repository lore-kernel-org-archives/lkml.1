Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbZEDMop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbZEDMop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 08:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbZEDMoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 08:44:34 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33612 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZEDMod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 08:44:33 -0400
Date: Mon, 4 May 2009 06:44:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504124433.GW8822@parisc-linux.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502013729.GI6996@linux.vnet.ibm.com> <20090503225616.GD8633@ZenIV.linux.org.uk> <20090504063431.GK7141@linux.vnet.ibm.com> <m11vr5jrba.fsf@fess.ebiederm.org> <20090504124129.GL7141@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504124129.GL7141@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 05:41:29AM -0700, Paul E. McKenney wrote:
> I am not sure that I correctly parsed these three sentences, but the
> justification should be pretty clear to anyone who has been paying any
> attention at all to recent industry news.

I think if there's one thing less reliable than an engineer's opinion
on a patent, it's a journalist's opinion on a patent lawsuit.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
