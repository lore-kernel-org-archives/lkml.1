Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYKXTh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYKXTh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYKXThQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:37:16 -0500
Received: from edu.joroinen.fi ([194.89.68.130]:55034 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbYKXThO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:37:14 -0500
X-Greylist: delayed 1412 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 14:37:14 EST
Date: Mon, 24 Nov 2008 21:13:40 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: Status of Xen in vanilla?
Message-ID: <20081124191340.GC15052@edu.joroinen.fi>
References: <20081111113838.GA3474@outback.rfc2324.org> <4919D4B1.7080703@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4919D4B1.7080703@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 10:53:37AM -0800, Jeremy Fitzhardinge wrote:
> Maximilian Wilhelm wrote:
> >Hi!
> >
> >I'm wondering about the status of Xen support in the vanilla kernel.
> >I know that DomU support is inside the kernel an evolving, but I did
> >not find an up-to-date hint about the status of Dom0 support.
> >
> >A while ago I read that it should be included in 2.6.28, but I do not
> >find any current pointer about the status of this.
> >  
> 
> .28 was a bit optimistic; .29 seems reasonable.  The current dom0 kernel 
> patches can boot up to a fully functional dom0 usersmode, and you can 
> start xend to see that domain 0 is running.  I *think* in theory you can 
> create a deviceless domain, but I haven't tried it.  I'm currently 
> working on blktap support.
> 
> I really need to put together a proper status update.  Now that dom0 
> usermode is working, its a much better base for other people start 
> contributing.
> 

This reminded me of updating http://wiki.xensource.com/xenwiki/XenParavirtOps

Now it says "Features added in 2.6.27".

Maybe you can go through the page, and update/add missing stuff.. 

-- Pasi
