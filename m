Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZEEIcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZEEIcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZEEIcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:32:04 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33385 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbZEEIcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:32:03 -0400
Message-ID: <49FFF97D.2010108@davidnewall.com>
Date: Tue, 05 May 2009 18:01:57 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Zero-day exploit details (Was: Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
 option)
References: <20090501210109.GA3079@infradead.org>	<20090502013729.GI6996@linux.vnet.ibm.com>	<20090503225616.GD8633@ZenIV.linux.org.uk>	<20090504063431.GK7141@linux.vnet.ibm.com>	<m11vr5jrba.fsf@fess.ebiederm.org>	<20090504124129.GL7141@linux.vnet.ibm.com>	<20090504124433.GW8822@parisc-linux.org>	<20090504130638.GN7141@linux.vnet.ibm.com>	<20090504132119.GX8822@parisc-linux.org>	<20090504143919.GA6740@linux.vnet.ibm.com>	<20090504150834.GZ8822@parisc-linux.org>	<1241451391.20170.12.camel@norville.austin.ibm.com>	<m14ow0hnal.fsf@fess.ebiederm.org>	<1241453259.20170.17.camel@norville.austin.ibm.com> <m1k54wal0j.fsf@fess.ebiederm.org>
In-Reply-To: <m1k54wal0j.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> All I know is that doing it the way you are doing seems like a bad
> idea.  Not discussing things or even the reason you can't discuss them
> seems foolish and leaves no one satisfied.

Heh heh.  Just kidding.
