Return-Path: <linux-kernel-owner+w=401wt.eu-S936509AbXFHOyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936509AbXFHOyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762619AbXFHOyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:54:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54335 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762443AbXFHOx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:53:58 -0400
Date: Fri, 8 Jun 2007 07:52:37 -0700
From: Greg KH <greg@kroah.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>, lenb@kernel.org
Subject: Re: [PATCH]: add parameter "struct bin_attribute *" in
	.read/.write methods for sysfs binary attributes
Message-ID: <20070608145237.GA6560@kroah.com>
References: <1181208695.5317.2.camel@localhost.localdomain> <20070608044809.GB28395@kroah.com> <1181291778.5575.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181291778.5575.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 04:36:18PM +0800, Zhang Rui wrote:
> 
> This is the refreshed patch. Thanks.

Can you resend with the proper changelog information, like the first
version you sent?

thanks,

greg k-h
