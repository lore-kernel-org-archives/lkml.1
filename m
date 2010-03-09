Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0CIVOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:14:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:53472 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0CIVOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:14:17 -0500
Date: Tue, 9 Mar 2010 13:01:50 -0800
From: Greg KH <gregkh@suse.de>
To: Joey Lee <jlee@novell.com>
Cc: mzxreary@0pointer.de, mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that is
 need load SCM
Message-ID: <20100309210150.GC32299@suse.de>
References: <4B96DD0202000023000146D6@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B96DD0202000023000146D6@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 05:42:58AM -0700, Joey Lee wrote:
> Hi Greg, 
> 
> Please kindly review the attached patch for removed the non-standard
> interface "threeg" in msi-laptop driver.

Looks good to me.

Matthew, are you going to be taking patches like this now?

If so, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch.

If not, please let me know.

thanks,

greg k-h
