Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZCPQJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZCPQJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZCPQJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:09:23 -0400
Received: from gw.goop.org ([64.81.55.164]:37525 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbZCPQJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:09:22 -0400
Message-ID: <49BE79AE.9000402@goop.org>
Date: Mon, 16 Mar 2009 09:09:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: bderzhavets@yahoo.com
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] Re: tip.git regression from "vsprintf: unify the
 format decoding layer for its 3 users"
References: <198719.14001.qm@web56104.mail.re3.yahoo.com>
In-Reply-To: <198719.14001.qm@web56104.mail.re3.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris Derzhavets wrote:
> It's not working:-
>
> root@ServerIntrepid:/usr/src/linux-2.6-xen# git checkout xen/dom0/hackery
> Already on "xen/dom0/hackery"
> root@ServerIntrepid:/usr/src/linux-2.6-xen# git reset --hard 
> remotes/xen/xen/dom0/hackery
> fatal: ambiguous argument 'remotes/xen/xen/dom0/hackery': unknown 
> revision or path not in the working tree.
>

The proper name is "remotes/<whatever you called your xen 
remote>/xen/dom0/hackery" (it might be "origin").

    J
