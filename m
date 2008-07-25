Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYGYLTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYGYLTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYGYLTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:19:10 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43837 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYGYLTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:19:08 -0400
Date: Fri, 25 Jul 2008 05:18:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080725111851.GB6701@parisc-linux.org>
References: <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx> <20080725032909.GA6701@parisc-linux.org> <20080725044234.GA18511@ldl.fc.hp.com> <488966DE.8020307@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488966DE.8020307@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 02:38:38PM +0900, Kenji Kaneshige wrote:
> >The hard part is figuring out a convention that we can all agree
> >on. ;) I've no strong feelings here, but of the options
> >presented, I lean towards "2a", "2b" or "2-1", "2-2".
> >
> 
> Only my hope is I don't want to look "2a" or "2-1" on normal platform.
> It should be "2" on normal platform.

Yes, the first slot will be "2", the second slot "2a" or "2-1" or
whatever we decide.  I don't have a strong feeling about the name.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
