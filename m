Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbYEPVHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbYEPVHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYEPVHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:07:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50770 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbYEPVHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:07:36 -0400
Date: Fri, 16 May 2008 17:07:20 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Dave Quigley <dpquigl@tycho.nsa.gov>, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/67] aufs document
Message-ID: <20080516210720.GG730@josefsipek.net>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <1210949976.14706.28.camel@moss-terrapins.epoch.ncsc.mil> <alpine.LNX.1.10.0805161731080.15590@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805161731080.15590@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 05:32:45PM +0200, Jan Engelhardt wrote:
> 
> On Friday 2008-05-16 16:59, Dave Quigley wrote:
> 
> >A couple of comments about this. First off you might want to reconsider
> >how you are breaking up the patches. 67 patches seems a bit much to me
> >and while the separation between patches is clear it seems that some of
> >them can be folded. Second I'm not sure if I haven't gotten it yet or if
> >it wasn't sent but I am missing an Email 0/67. Typically this contains a
> 
> No 0/67 unfortunately, and --no-chain was also missing when calling
> git-send-email. (Argh, git-send-email should default to no-chain!)

If you use Guilt, it does all the brain-damage removal for you ;)
(guilt-patchbomb to be exact)

Josef 'Jeff' Sipek.

-- 
I'm somewhere between geek and normal.
		- Linus Torvalds
