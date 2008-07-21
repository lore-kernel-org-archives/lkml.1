Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYGUKFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYGUKFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbYGUKFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:05:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:40860 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYGUKFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gzrw2Kd8G6nHuTgLQosK520FrhLQB1yVXrjdcqyz8k8y5yh4Ffrg4Jf1OCQx9fHS/5
         HLWF81nC2RBK7XbqrQtdEqsktGTVvRYUgIGHT7F2Du/HySZUqZ0TegeUSpO5ykUmZ1pv
         T6fCYRDw8XU0cvE3YUIkftOkELuF0HTZz+B+0=
Date: Mon, 21 Jul 2008 14:05:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721100520.GA7694@lenovo>
References: <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk> <20080721080427.GC6662@lenovo> <488448A1.3030608@cn.fujitsu.com> <20080721084443.GD20011@lenovo> <48844FE4.1040708@cn.fujitsu.com> <84144f020807210206r12b121c6o8ce88a752493b0cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020807210206r12b121c6o8ce88a752493b0cf@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Mon, Jul 21, 2008 at 12:06:55PM +0300]
| Hi,
| 
| On Mon, Jul 21, 2008 at 11:59 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
| >> well, as only Al find new version more or less correct we could
| >> update yours.
| >
| > Sorry, I don't quite catch what you mean for my poor English. :(
| >
| > Do you expect me to update and resend my version? or do you mean don't
| > drop the patch in -mm but you will resend a patch based against it?
| 
| Andrew already merged your patch so I think Cyrill should just send a
| new patch against -mm.
| 
|                           Pekka
|

Thanks guys, will send patch against -mm soon (a bit busy now)
 
		- Cyrill -
