Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbYGUKMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbYGUKMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYGUKLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:11:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49360 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYGUKLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:11:54 -0400
Message-ID: <4884608B.2020902@cn.fujitsu.com>
Date: Mon, 21 Jul 2008 18:10:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
References: <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk> <20080721080427.GC6662@lenovo> <488448A1.3030608@cn.fujitsu.com> <20080721084443.GD20011@lenovo> <48844FE4.1040708@cn.fujitsu.com> <84144f020807210206r12b121c6o8ce88a752493b0cf@mail.gmail.com> <20080721100520.GA7694@lenovo>
In-Reply-To: <20080721100520.GA7694@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Pekka Enberg - Mon, Jul 21, 2008 at 12:06:55PM +0300]
> | Hi,
> | 
> | On Mon, Jul 21, 2008 at 11:59 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> | >> well, as only Al find new version more or less correct we could
> | >> update yours.
> | >
> | > Sorry, I don't quite catch what you mean for my poor English. :(
> | >
> | > Do you expect me to update and resend my version? or do you mean don't
> | > drop the patch in -mm but you will resend a patch based against it?
> | 
> | Andrew already merged your patch so I think Cyrill should just send a
> | new patch against -mm.
> | 
> |                           Pekka
> |
> 
> Thanks guys, will send patch against -mm soon (a bit busy now)
>  

Oh, I just sent out a mix-up patch because I'm going to get off work but I didn't
get your respond, you can just ignore it.

