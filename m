Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476Ab0ASAPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0ASAPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581Ab0ASAP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:15:26 -0500
Received: from kroah.org ([198.145.64.141]:57308 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab0ASAPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:15:16 -0500
Date: Mon, 18 Jan 2010 16:13:54 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Remove cflags from Makefile and fix Kconfig
Message-ID: <20100119001354.GF27551@kroah.com>
References: <1263849774-23152-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263849774-23152-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 01:22:54PM -0800, Mark Allyn wrote:
> This patch fixes bothe the Makefile and the Kconfig file

Fixes in what way?  The existing one does not look buggy to me.

thanks,

greg k-h
