Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbYBWHsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbYBWHsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 02:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYBWHsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 02:48:06 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769AbYBWHsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 02:48:03 -0500
Date: Fri, 22 Feb 2008 23:47:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/16] um: use get_personality()
Message-Id: <20080222234725.a721977c.akpm@linux-foundation.org>
In-Reply-To: <20080222.203900.43426213.xiyou.wangcong@gmail.com>
References: <12035064241213-git-send-email-xiyou.wangcong@gmail.com>
	<12035064291055-git-send-email-xiyou.wangcong@gmail.com>
	<20080220162734.GC8828@c2.user-mode-linux.org>
	<20080222.203900.43426213.xiyou.wangcong@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 20:39:00 +0800 (CST) WANG Cong <xiyou.wangcong@gmail.com> wrote:

> From: Jeff Dike <jdike@addtoit.com>
> Subject: Re: [PATCH 09/16] um: use get_personality()
> Date: Wed, 20 Feb 2008 11:27:34 -0500
> Message-ID: <20080220162734.GC8828@c2.user-mode-linux.org>
> 
> > On Wed, Feb 20, 2008 at 07:19:13PM +0800, WANG Cong wrote:
> > > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> > 
> > Looks good - you should add some sort of changelog though.
> > 
> 
> Thanks, Jeff.
> 
> It seems that you're the only one who received this patchset of mine.
> And I found that lkml.org didn't receive these neither. ;(
> 
> I don't know if Andrew received all of them, if not, I must resend.
> 

No, I don't seem to have received them.
