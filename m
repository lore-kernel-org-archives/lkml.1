Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYGUKRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYGUKRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbYGUKRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:17:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:39043 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbYGUKRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=reHLW1kq9shbZAljNb3nUASAAWKSSxp2c4JZ0ofXU5o5ceiQvXBPhJRcfBlFeVrrpk
         mvlrU40gJTzqFj51dCb2DvAzsdGFFOngdhzcWTLm2TgsDSx1208zmNM0e/fMkvOGyna/
         Rt3uEzQkZ2ptMK8r+Y6E8hZJsP8wGXy0bqvD8=
Date: Mon, 21 Jul 2008 14:17:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721101736.GC7694@lenovo>
References: <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk> <20080721080427.GC6662@lenovo> <488448A1.3030608@cn.fujitsu.com> <20080721084443.GD20011@lenovo> <48844FE4.1040708@cn.fujitsu.com> <84144f020807210206r12b121c6o8ce88a752493b0cf@mail.gmail.com> <20080721100520.GA7694@lenovo> <4884608B.2020902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4884608B.2020902@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Li Zefan - Mon, Jul 21, 2008 at 06:10:19PM +0800]
| Cyrill Gorcunov wrote:
| > [Pekka Enberg - Mon, Jul 21, 2008 at 12:06:55PM +0300]
| > | Hi,
| > | 
| > | On Mon, Jul 21, 2008 at 11:59 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
| > | >> well, as only Al find new version more or less correct we could
| > | >> update yours.
| > | >
| > | > Sorry, I don't quite catch what you mean for my poor English. :(
| > | >
| > | > Do you expect me to update and resend my version? or do you mean don't
| > | > drop the patch in -mm but you will resend a patch based against it?
| > | 
| > | Andrew already merged your patch so I think Cyrill should just send a
| > | new patch against -mm.
| > | 
| > |                           Pekka
| > |
| > 
| > Thanks guys, will send patch against -mm soon (a bit busy now)
| >  
| 
| Oh, I just sent out a mix-up patch because I'm going to get off work but I didn't
| get your respond, you can just ignore it.
|

it's ok - since you did my work for me :) Thanks.
 
		- Cyrill -
