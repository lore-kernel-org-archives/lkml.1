Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbZHRR7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbZHRR7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbZHRR7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:59:16 -0400
Received: from kroah.org ([198.145.64.141]:33795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759298AbZHRR7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:59:15 -0400
Date: Tue, 18 Aug 2009 10:47:55 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
Message-ID: <20090818174755.GH6123@kroah.com>
References: <1249052833-9655-1-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-2-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-3-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-4-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-5-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-6-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-7-git-send-email-jason.wessel@windriver.com>
 <1249052833-9655-8-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249052833-9655-8-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 10:07:10AM -0500, Jason Wessel wrote:
> If the EHCI debug port is initialized and in use, the EHCI host
> controller driver must follow two rules.

As there was some discussion of this patch, do you have a new one?

I've applied the first 6 in the series, care to resend 7-10 with the
proper versions?

thanks,

greg k-h
