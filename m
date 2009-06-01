Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbZFAE7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbZFAE7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 00:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZFAE6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 00:58:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55995
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbZFAE6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 00:58:54 -0400
Date: Sun, 31 May 2009 21:58:55 -0700 (PDT)
Message-Id: <20090531.215855.142666346.davem@davemloft.net>
To: nix@esperi.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: 2.6.30rc7: ksoftirqd CPU saturation (x86-64 only, not x86-32)
 (e1000e-related?)
From: David Miller <davem@davemloft.net>
In-Reply-To: <87ljoczu3p.fsf@hades.wkstn.nix>
References: <87prdozxns.fsf@hades.wkstn.nix>
	<20090531170350.1355b3f1.akpm@linux-foundation.org>
	<87ljoczu3p.fsf@hades.wkstn.nix>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nix <nix@esperi.org.uk>
Date: Mon, 01 Jun 2009 01:16:26 +0100

> I plan to try out 2.6.29 (and back to 2.6.25 or thereabouts) tomorrow
> and see if it ever worked: if it did I'll bisect for it (rendered tricky
> by the out-of-tree e1000e driver, but doable: it would be easier if I
> had a clue where the e1000-devel git tree is, if anywhere, but I still
> have no idea despite considerable searching).

Why are you using the out-of-tree e1000e driver?  What's wrong
with the one in the tree? :-)
