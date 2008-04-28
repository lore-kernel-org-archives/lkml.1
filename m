Return-Path: <linux-kernel-owner+w=401wt.eu-S936407AbYD1RQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936407AbYD1RQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936399AbYD1RQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:16:27 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:35125 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S936397AbYD1RQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:16:26 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 13:16:26 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: Re: [patch] doc: fix an incorrect suggestion to pass NULL for PCI like buses
Date: Mon, 28 Apr 2008 10:09:40 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       willy@linux.intel.com
References: <392740.53131.qm@web52007.mail.re2.yahoo.com>
In-Reply-To: <392740.53131.qm@web52007.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281009.40904.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2008 9:33 am Matti Linnanvuori wrote:
> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
>
> Fix an incorrect suggestion to pass NULL to pci_alloc_consistent
> for PCI like buses where devices don't have struct pci_dev (like ISA,
> EISA).
>
> Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

This one was whitespace damaged too, but I fixed it up by hand and applied it.  
Before sending future patches, please fix up your mailer so that the diff is 
preserved...

Thanks,
Jesse
