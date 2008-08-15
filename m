Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYHOCat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYHOCat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYHOCal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:30:41 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38767 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYHOCak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AiVybGwasbWrfAdVniH5iH693/zgsNImJqB/iEdcJme4+AhKpPS2XlBZRV5wcpYIdJ
         2ZddtSq9/NS20/cqzEaN8+jFe+Zddf6A0DjdKlYz5SwhIuDFrKwi3k9yw/YPJI04+JNl
         o6zu7FRnwxfdQh92RYL4EMgfKucgtYxukd4s0=
Date: Thu, 14 Aug 2008 22:30:30 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.27-rc0 (round 2)
Message-ID: <20080815023030.GC9438@anvil.corenet.prv>
References: <20080815022826.GB9438@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815022826.GB9438@anvil.corenet.prv>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 10:28:26PM -0400, Dmitry Torokhov wrote:
> Hi Linus,
> 
> Please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
> 	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> to receive updates for the input subsystem. You will get a bunch of
> small fixes, the change to evdev to print an warning abount invalid
> parameters to EVIOCGBIT ioctl and a new driver for Macbook Air
> touchpads.
> 

Oops, that should read "Input updates for 2.6.27-rc3", damn mutt.

-- 
Dmitry
