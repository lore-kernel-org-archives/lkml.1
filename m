Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZEYJkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZEYJkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZEYJkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:40:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZEYJkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:40:41 -0400
Date: Mon, 25 May 2009 11:47:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, Tomasz Chmielewski <mangoo@wpkg.org>,
       mingo@elte.hu, jeremy@goop.org, Alan <alan@lxorguk.ukuu.org.uk>,
       Gerd Hoffmann <kraxel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090525094706.GX846@one.firstfloor.org>
References: <4A1A59DD.7030101@wpkg.org> <20090525091530.GW846@one.firstfloor.org> <4A1A81770200007800002593@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A81770200007800002593@vpn.id2.novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 10:31:03AM +0100, Jan Beulich wrote:
> >>> Andi Kleen <andi@firstfloor.org> 25.05.09 11:15 >>>
> >To my knowledge the only CPUs with broken PAT are some very old Pentium
> >Pros dating from back the time when PAT was new and noone used it.
> >On those it should be disabled or the high bits not used.
> 
> ??? See PentiumIII erratum E27.

Thanks for the correction.  

It's still all pretty old CPUs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
