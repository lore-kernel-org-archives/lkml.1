Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604Ab0ASALe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0ASALe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123Ab0ASALd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:11:33 -0500
Received: from kroah.org ([198.145.64.141]:57288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab0ASALc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:11:32 -0500
Date: Mon, 18 Jan 2010 16:07:50 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Add Linux Driver for Intel Langwell Watchdog
Message-ID: <20100119000750.GA27162@kroah.com>
References: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 01:24:19PM -0800, Mark Allyn wrote:
> This patch adds a Linux device driver for the Intel Langwell
> Watchdog device found on the Intel Mobile Internet device.

And it breaks the build, so how could we expect to apply it?

Please work to get the needed basic core upstream before adding drivers,
otherwise it just does not work.

thanks,

greg k-h
