Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZLUDME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZLUDME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 22:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbZLUDMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 22:12:00 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45495 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbZLUDL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 22:11:59 -0500
Date: Sun, 20 Dec 2009 22:07:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-12-18
Message-ID: <20091221030738.GA2398@tuxdriver.com>
References: <20091218211945.GC2828@tuxdriver.com>
 <20091220.001736.189688434.davem@davemloft.net>
 <20091220133800.GA4700@tuxdriver.com>
 <20091220.182910.226760127.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091220.182910.226760127.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 06:29:10PM -0800, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Sun, 20 Dec 2009 08:38:00 -0500
> 
> > On Sun, Dec 20, 2009 at 12:17:36AM -0800, David Miller wrote:
> >> From: "John W. Linville" <linville@tuxdriver.com>
> >> Date: Fri, 18 Dec 2009 16:19:45 -0500
> >> 
> >> > Please let me know if there are problems!
> >> 
> >> Your tree is based upon Linus's not net-2.6
> >> so when I pulled I got a lot of unrelated
> >> commits.
> >> 
> >> Please fix this, thanks.
> > 
> > It's based on 2.6.33-rc1.  Are you not going to pull that into net-2.6?
> 
> Why in the world should I?  There are no conflicts to resolve
> that I know of.
> 
> And if there are no conflicts to resolve, pulling in Linus's
> tree just makes future pulls into his tree more ugly.
> 
> This is pretty standard practice, but in any event you shouldn't ever
> care.
> 
> You should simply always work against net-2.6, there is no reason to
> work against any other tree.
> 
> This is a pretty fundamental thing, I don't know why you based against
> Linus's tree instead of net-2.6.  Now you have to rebase already :-/

My mistake!  For some reason I just thought that pulling from -rc1 was
your normal practice -- now I can't figure what gave me that idea...

Anyway, might as well have one more rebase now.  I'll straighten-out
my trees tomorrow morning and resubmit.

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
