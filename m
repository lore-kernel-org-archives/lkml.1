Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZHSQJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZHSQJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZHSQJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:09:17 -0400
Received: from kroah.org ([198.145.64.141]:50473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbZHSQJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:09:16 -0400
Date: Wed, 19 Aug 2009 09:01:44 -0700
From: Greg KH <greg@kroah.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
Subject: Re: [RFC] [PATCH v3 1/2] introduce ALS sysfs class
Message-ID: <20090819160144.GB1020@kroah.com>
References: <1250671229.17853.51.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250671229.17853.51.camel@rzhang-dt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 04:40:29PM +0800, Zhang Rui wrote:
> --- /dev/null
> +++ linux-2.6/Documentation/ABI/testing/sysfs-class-als
> @@ -0,0 +1,137 @@
> +Ambient Light Sensor Sysfs driver How To
> +=========================

<snip>

While this is a nice document, it does not follow the standard that the
files in Documentation/ABI/ should be in.  Can you please read
Documentation/ABI/README and convert the file to follow that?

thanks,

greg k-h
