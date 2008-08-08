Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbYHHFSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbYHHFSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 01:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYHHFSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 01:18:48 -0400
Received: from tundra.namei.org ([65.99.196.166]:41205 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYHHFSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 01:18:47 -0400
Date: Fri, 8 Aug 2008 15:17:49 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Peter Dolding <oiaohm@gmail.com>
cc: Eric Paris <eparis@redhat.com>, Pavel Machek <pavel@suse.cz>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
In-Reply-To: <e7d8f83e0808071705u32b726bjc19d8935960f37b9@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0808081515320.23689@tundra.namei.org>
References: <20080806064418.6afa0672@infradead.org>  <20080806141656.8B44B2FE94A@pmx1.sophos.com>  <20080807092800.GA22222@atrey.karlin.mff.cuni.cz>  <e7d8f83e0808070721l2dd38f0dyd0366520e9131b1a@mail.gmail.com>  <1218119483.5837.112.camel@localhost.localdomain>
 <e7d8f83e0808071705u32b726bjc19d8935960f37b9@mail.gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Peter Dolding wrote:

> TALPA is a failed design.  It has too many holes.  They need to be
> closed.  Fastest way to close them is just merge its ideas into
> Credentials.

Sound great, looking forward to your patches!

I suggest developing them against:

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds

Thanks.


- James
-- 
James Morris
<jmorris@namei.org>
