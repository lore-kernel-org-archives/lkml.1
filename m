Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZK0Wai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZK0Wai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 17:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZK0Wai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 17:30:38 -0500
Received: from stinky.trash.net ([213.144.137.162]:55844 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZK0Wah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 17:30:37 -0500
Message-ID: <4B105311.1020005@trash.net>
Date: Fri, 27 Nov 2009 23:30:41 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Patrick Mullaney <pmullaney@novell.com>
CC: netdev@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [PATCH v2] netdevice: provide common routine for macvlan and
 vlan	operstate management
References: <20091127220717.14078.6058.stgit@mimic.site>
In-Reply-To: <20091127220717.14078.6058.stgit@mimic.site>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Mullaney wrote:
> Applies to net-2.6.git/master:0135ae0b9)
> 
> Provide common routine for the transition of operational state for a leaf
> device during a root device transition. This updates a previous patch in
> my venet macvlan series and fixes the problems that Arnd pointed out.
> 
> Is submitting this applied to net-next a more better approach?

Yes, please base this patch on net-next.

> Signed-off-by: Patrick Mullaney <pmullaney@novell.com>

Acked-by: Patrick McHardy <kaber@trash.net>
