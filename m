Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYFRMxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYFRMxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYFRMxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:53:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:9782 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYFRMxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PsWoWF1bjSORm/xuCXDGATEseLEAPO26VwfBnWqyrasfUmadOEFjkv56t50QvYagoU
         uRFsc5hf6q3ktlyVeKKwuPIXaiw5gdrh/9R/t5VEe6SzC4oW44e4JjpmOPT+5s6lfOtS
         Y/8v8Yztu7EfgtT6whZUosu8ebomQx2uL/k2k=
Date: Wed, 18 Jun 2008 08:53:12 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.26-rc6
Message-ID: <20080618085024.ZZRA012@mailhub.coreip.homeip.net>
References: <20080617180508.GA9057@anvil.corenet.prv> <Pine.LNX.4.64.0806181156250.21793@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806181156250.21793@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, Jun 18, 2008 at 11:58:20AM +0200, Jiri Kosina wrote:
> 
> Hi Dmitry,
> 
> how about my patch
> 
> 	Input: i8042 - add Intel D845PESV to nopnp list
> 
> Not that it couldn't wait for next merge window, I just want to make sure 
> that it doesn't get lost.
> 

It is in my 'next' branch. Since 'nopnp' list is new I thought the
patch should wait for .27.

-- 
Dmitry
