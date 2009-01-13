Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbZAMXmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbZAMXmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbZAMXlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:41:04 -0500
Received: from kroah.org ([198.145.64.141]:59311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757923AbZAMXlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:41:03 -0500
Date: Tue, 13 Jan 2009 15:39:32 -0800
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [0/7] Distributed storage for drivers/staging merge request
Message-ID: <20090113233932.GA18000@kroah.com>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231887933-17843-1-git-send-email-zbr@ioremap.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:05:26AM +0300, Evgeniy Polyakov wrote:
> Patches were split on per-file basis, so tree in the middle of the series will not
> compile, which should not be a problem, since kconfig/makefile changes are introduced
> in the latest patch.

Looks good to me, but do we need the "export these symbols" patch to get
this to work properly as well?

Also, can you send me a patch with a TODO file in the
drivers/staging/dst/ directory, detailing what needs to be done on it to
move it over to the main portion of the kernel?

thanks,

greg k-h
