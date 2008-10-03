Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYJCOwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYJCOwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYJCOwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:52:31 -0400
Received: from kroah.org ([198.145.64.141]:43285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753210AbYJCOwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:52:30 -0400
Date: Fri, 3 Oct 2008 07:49:24 -0700
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Support for Silicon C2 Interface.
Message-ID: <20081003144924.GA5050@kroah.com>
References: <1223044589-31741-1-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223044589-31741-1-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 04:36:28PM +0200, Rodolfo Giometti wrote:
> C2 port implements a two wire serial communication protocol (bit
> banging) designed to enable in-system programming, debugging, and
> boundary-scan testing on low pin-count Silicon Labs devices.
> 
> Main references are at Silicon Laboratories site:
> 
> * AN127: FLASH Programming via the C2 Interface
>      http://www.silabs.com/public/documents/tpub_doc/anote/Microcontrollers/Small_Form_Factor/en/an127.pdf
> 
> * C2 Specification
>      http://www.silabs.com/public/documents/tpub_doc/spec/Microcontrollers/en/C2spec.pdf
> 
> Currently this code supports only flash programming through sysfs
> interface but extensions shoud be easy to add.
> 
> I know that this (proposal) patch may be incomplete but I'd like to
> know what you are thinking about it before continuing further. For example
> I'd like to know if should I put the C2 port core here or into proper
> subdirectory of linux/drivers/misc/ where clients can be placed also.

Hm, I seem to be missing the patch here :(

thanks,

greg k-h
