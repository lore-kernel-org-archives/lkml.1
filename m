Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZD0TlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZD0TlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZD0Tk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:40:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:37577 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZD0Tk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:40:56 -0400
Message-ID: <49F60A3A.4060402@freescale.com>
Date: Mon, 27 Apr 2009 14:40:42 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090327 SeaMonkey/2.0a3
MIME-Version: 1.0
To: David Hawkins <dwh@ovro.caltech.edu>
CC: Liu Dave-R63238 <DaveLiu@freescale.com>, Ira Snyder <iws@ovro.caltech.edu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu>
In-Reply-To: <49F608B7.9080409@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Hawkins wrote:

> Would you like some sort of summary of this info for a commit
> message?

That's probably overkill.  I just want a sentence or two that tells
someone looking at the code casually that the behavior of reading PCI
memory might be different than what they expect.

> Would you like us to check any other transaction/register combos?

Yes, could you try this on non-PCI memory?

-- 
Timur Tabi
Linux kernel developer at Freescale
