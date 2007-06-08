Return-Path: <linux-kernel-owner+w=401wt.eu-S970661AbXFHS3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970661AbXFHS3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764732AbXFHS3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:29:35 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:37538 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969542AbXFHS3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:29:34 -0400
Date: Fri, 8 Jun 2007 11:29:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       James Bottomley <James.Bottomley@steeleye.com>,
       AACRAID <aacraid@adaptec.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch 37/54] SCSI: aacraid: Correct sa
	platformsupport. (Was: [Bug 8469] Bad EIP value on pentium3
	SMPkernel-2.6.21.1)
Message-ID: <20070608182917.GI3723@sequoia.sous-sol.org>
References: <20070608174545.GZ3723@sequoia.sous-sol.org> <AE4F746F2AECFC4DA4AADD66A1DFEF01AB8567@otce2k301.adaptec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01AB8567@otce2k301.adaptec.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Salyzyn, Mark (mark_salyzyn@adaptec.com) wrote:
> Yes, split the patch into the two pieces for 2.6.21.1/2.6.21.4

Sorry, didn't parse.  Are you suggesting to use the patch I included
(which simply drops the ->adapter_restart init), or the original patch
plus Mark Havercamp's patch to add ->adapter_restart?

thanks,
-chris
