Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZEDGel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZEDGel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 02:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZEDGea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 02:34:30 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58968 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZEDGe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 02:34:29 -0400
Date: Sun, 3 May 2009 23:34:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: tridge@samba.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504063431.GK7141@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502013729.GI6996@linux.vnet.ibm.com> <20090503225616.GD8633@ZenIV.linux.org.uk> <18942.9606.411013.714178@samba.org> <m1ljpdl8yr.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ljpdl8yr.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 10:42:52PM -0700, Eric W. Biederman wrote:
> The only reason I can see for not ultimately talking about things publicly
> is if this is one company making shady deals with another company in which
> case I do not see why the maintenance burden for those decision should
> fall on the linux community as a whole.

Another reason is that past experience would indicate that anything we
say in public and and will be used against us.

							Thanx, Paul
