Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbYD0E0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbYD0E0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 00:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYD0E0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 00:26:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:62042 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYD0E0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 00:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZuaFoo1z0B8fnGJnKoG0dhzpo4hi/qRUtlKTgUg1oHKA6vkFvrnlJQXVwS5yRIQf8KNVRxVpNHW9aXLowZHqFiBmXfqS+1KMOxvGGZ8ISUVctaO7vBmgvgrQcKD2DC77KS93XMZU+DHgIcqiNYgvpld4ZhznAgoTQRV+/Uc3+YI=
Date: Sun, 27 Apr 2008 00:26:36 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.26-rc0
Message-ID: <20080427042636.GC29127@anvil.corenet.prv>
References: <20080425034751.GA12910@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425034751.GA12910@anvil.corenet.prv>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Apr 24, 2008 at 11:47:51PM -0400, Dmitry Torokhov wrote:
> Hi Linus,
> 
> Please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
> 	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> to receive updates for the input subsystem.

Please do another pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to get the fix for build failure reported by Ingo.

Changelog:
---------

Dmitry Torokhov (1):
      Input: xpad - fix build failure


Diffstat:
--------

 drivers/input/joystick/xpad.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

-- 
Dmitry
