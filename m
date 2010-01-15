Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866Ab0AOAbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0AOAbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098Ab0AOAbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:31:43 -0500
Received: from kroah.org ([198.145.64.141]:46491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab0AOAbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:31:42 -0500
Date: Thu, 14 Jan 2010 16:24:19 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: [PATCH] staging/dream: add missing include files/fix
 compilation
Message-ID: <20100115002419.GA25643@kroah.com>
References: <20091225205917.GA25761@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091225205917.GA25761@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 09:59:18PM +0100, Pavel Machek wrote:
> This adds missing include files, so it should now compile. ifdef
> guards were added to Kconfig, so it should not cause problems on
> non-arch-msm machines.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Odd, this doesn't apply to the linux-next tree, some of the files are
already there.

Care to refresh this?

thanks,

greg k-h
