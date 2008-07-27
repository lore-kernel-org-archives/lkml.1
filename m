Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYG0Hz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYG0Hz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 03:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYG0HzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 03:55:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59422
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbYG0HzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 03:55:18 -0400
Date: Sun, 27 Jul 2008 00:55:18 -0700 (PDT)
Message-Id: <20080727.005518.08712012.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: roland@redhat.com, linuxppc-dev@ozlabs.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] powerpc tracehook
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217145165.11188.132.camel@pasglop>
References: <20080727064859.69692154280@magilla.localdomain>
	<1217145165.11188.132.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sun, 27 Jul 2008 17:52:45 +1000

> On Sat, 2008-07-26 at 23:48 -0700, Roland McGrath wrote:
> > These patches are posted for review, but you can just pull the GIT branch
> > if you prefer.  Patch 1/5 corrects a long-standing (minor) error in ptrace
> > behavior.  The others change no existing behavior, just enable new and
> > future features to work on the arch.
> 
> Hi Roland !
> 
> Thanks for this. I haven't followed the story of tracehook so far, are
> those patches dependent on something else or it's all already upstream
> and do you think that's still 2.6.27 material ?

The infrastructure is in Linus's tree.
