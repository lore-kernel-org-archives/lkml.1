Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab0BDRd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:33:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37552
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933594Ab0BDRdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:33:16 -0500
Date: Thu, 04 Feb 2010 09:33:29 -0800 (PST)
Message-Id: <20100204.093329.164097227.davem@davemloft.net>
To: peppe.cavallaro@st.com
Cc: jkosina@suse.cz, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, lsorense@csclub.uwaterloo.ca,
       netdev@vger.kernel.org, daniel@caiaq.de
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B6AD11D.6050402@st.com>
References: <alpine.LNX.2.00.1002041052020.15395@pobox.suse.cz>
	<4B6AC28D.6090204@st.com>
	<4B6AD11D.6050402@st.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Date: Thu, 04 Feb 2010 14:52:29 +0100

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Giuseppe CAVALLARO wrote:
>> Hi Jiri,
>> 
>> The stmmac driver included in net-next has been restructured: for this
>> reason both gmac.c and mac100.c files do not exist any more.
>> 
>> Let me know if I can help on this; I mean I'm happy to apply this latest
>> changes to the stmmac in net-next and send a new patch.
> 
> patch attached
> I hope it could be useful.

Applied, thank you.
