Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbZDDNWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbZDDNWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 09:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbZDDNWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 09:22:03 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:23741 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZDDNWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 09:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dMFVi2/8ftIjkFcezV28jn7TthiwSIXsnylJzfAOUY+pMtfBSCAA76xSKEp/VpDViM
         Plu6kI8xBwweksOMwDg8X51BurJha2NVz1BPDt4GkOFmQUhk5sUenTwPkeAFKLikrtTu
         6dc2QeHIigv5fvOeTcL1hmHD/feXXZnDPliGI=
MIME-Version: 1.0
In-Reply-To: <3181463559098978317@unknownmsgid>
References: <3181463559098978317@unknownmsgid>
Date: Sat, 4 Apr 2009 09:21:58 -0400
Message-ID: <625fc13d0904040621g7b89cd2cq9681ce80635a65c4@mail.gmail.com>
Subject: Re: [PATCH -tip] Convert CONFIG_SMP=y powerpc defconfigs to TREE_RCU.
From: Josh Boyer <jwboyer@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, niv@us.ibm.com, manfred@colorfullife.com,
       peterz@infradead.org, lethal@linux-sh.org, kernel@wantstofly.org,
       andi@firstfloor.org, kyle@mcmartin.ca, deller@gmx.de,
       davem@davemloft.net, ralf@linux-mips.org, jes@sgi.com,
       benh@kernel.crashing.org, paulus@samba.org, anton@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 8:27 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>

Why would one want to do this?  The commit log doesn't explain the
switch and why it's great.  Mostly because the commit log doesn't
exist.  (I'll stop channeling Andrew now)

It also might be a good idea to CC the linuxppc-dev list for this
patch.  Or at least Kumar for the mpc86xx changes.

josh
