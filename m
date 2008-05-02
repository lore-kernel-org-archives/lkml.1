Return-Path: <linux-kernel-owner+w=401wt.eu-S965313AbYEBVfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965313AbYEBVfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbYEBVey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:34:54 -0400
Received: from lazybastard.de ([212.112.238.170]:58731 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbYEBVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:34:52 -0400
Date: Fri, 2 May 2008 23:34:38 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080502213438.GE24080@logfs.org>
References: <20080502133234.GA24080@logfs.org> <87k5icvcm4.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k5icvcm4.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 19:29:07 +0200, Andi Kleen wrote:
> Jörn Engel <joern@logfs.org> writes:
> >
> > So should it simmer in -next and -mm for another month?  Should it go
> > straight into -linus?
> 
> The main criteria for it going to Linus should be if you would really
> trust your data to it now. Would you put your $HOME on it? Merging file 
> systems too early can quickly ruin their name and that taint is hard
> to ever get rid again then (e.g. happened to JFS) 

Right now I don't, mainly because file creat performance is still too
bad on the devices I can buy and attach to my notebook.  But something
like bittorrent would be an excellent testbed where few large files are
created and performance should actually be good enough.  Time to eat my
dogfood.

Jörn

-- 
All art is but imitation of nature.
-- Lucius Annaeus Seneca
