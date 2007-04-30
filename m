Return-Path: <linux-kernel-owner+w=401wt.eu-S1423303AbXD3OdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423303AbXD3OdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423304AbXD3OdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:33:15 -0400
Received: from gherkin.frus.com ([192.158.254.49]:58306 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423303AbXD3OdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:33:14 -0400
Subject: Re: BAD_SG_DMA panic in aha1542
In-Reply-To: <1177712499.3688.25.camel@mulgrave.il.steeleye.com>
 "from James Bottomley at Apr 27, 2007 05:21:39 pm"
To: James Bottomley <James.Bottomley@SteelEye.com>
Date: Mon, 30 Apr 2007 09:33:12 -0500 (CDT)
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070430143312.74403DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies to all concerned for an unfortunate delay in resolving this.
I chose "unwisely" when I picked a popular experimental distro's
2.6.20 kernel source as a base for my troubleshooting efforts.  The
resulting kernel panics when it tries to load the initial ramdisk, and
I don't have the patience to track down which of the turned-on-by-default
experimental configuration parameters might be causing the problem.

I'll go retrieve a more conservatively-configured source tree (closer to
what DSL-N uses) and start over...

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
