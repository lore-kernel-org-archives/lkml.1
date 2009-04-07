Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZDGDZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZDGDZC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:25:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZDGDYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:24:49 -0400
Received: from outbound-mail-312.bluehost.com ([67.222.54.5]:59661 "HELO
	outbound-mail-312.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751268AbZDGDYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:24:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OFAs9ODN4h66yj+M2dgv9LAKmSJmZjKTxkmsxA5FVP8CF255by85lA+cQVqnXWlKbhv1h7Mr2Xiw6soKpQdDkvuyVle00z2eHaPldP4BkXp7y0jH4hEbWeZv8MC0dk1F;
Date: Mon, 6 Apr 2009 20:24:41 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20090406202441.1c050ec6@hobbes>
In-Reply-To: <alpine.LFD.2.00.0904061931160.4010@localhost.localdomain>
References: <20090406.175752.236260059.davem@davemloft.net>
	<alpine.LFD.2.00.0904061824410.4010@localhost.localdomain>
	<20090406.190745.263215778.davem@davemloft.net>
	<alpine.LFD.2.00.0904061931160.4010@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 19:32:11 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 6 Apr 2009, David Miller wrote:
> 
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > Date: Mon, 6 Apr 2009 18:25:31 -0700 (PDT)
> > > 
> > > 
> > > The sky2 driver is buggered (by the previous pull, I presume).
> > > Some PCI interaction. NULL pointer dereference at boot.
> > 
> > Fixed in the PCI tree, have you pulled that one yet?
> 
> Nobody has even _asked_ me to pull.
> 
> What's the point of having fixes available if they aren't merged?

I just pushed it into my repo today and wanted at least a day of
linux-next before asking you to pull.

-- 
Jesse Barnes, Intel Open Source Technology Center
