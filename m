Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYDQES3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYDQES3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYDQESM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:18:12 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:37306 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYDQESK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=kbFi1+ugoXnDVNpZwHxxW22RptsQ9tWjUz/kfdok9QPp4DtbpW9a0jhhZbvXzDy4OOjAbLmEUVBIhmFVILfppdZ8mH6l0D23ucsEP3z27JbHyL6DOj8S1L0jhOvV8Ey7377HTEHrhoOdqKMOLuOuvNgBuT8v6AURtkML2Bgb2R4=
Date: Thu, 17 Apr 2008 12:13:56 +0800 (CST)
Message-Id: <20080417.121356.08390959.xiyou.wangcong@gmail.com>
To: jdike@addtoit.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] UML: Clean up arch/um/drivers/ubd_kern.c
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080416152019.GA8693@c2.user-mode-linux.org>
References: <20080415133325.GA7882@c2.user-mode-linux.org>
	<20080416.133919.133424295.xiyou.wangcong@gmail.com>
	<20080416152019.GA8693@c2.user-mode-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>
Date: Wed, 16 Apr 2008 11:20:19 -0400
> On Wed, Apr 16, 2008 at 01:39:19PM +0800, WANG Cong wrote:
> > From: Jeff Dike <jdike@addtoit.com>
> > Date: Tue, 15 Apr 2008 09:33:25 -0400
> > > On Mon, Apr 14, 2008 at 11:42:37PM -0700, Andrew Morton wrote:
> > > > omg, when checkpatch bit into this patch my CPU melted.
> 
> Here's a cleaned up version.
> 
>        	 	    Jeff

Looks OK for me. Thank you!
