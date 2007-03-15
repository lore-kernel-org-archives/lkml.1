Return-Path: <linux-kernel-owner+w=401wt.eu-S1751486AbXCOShz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbXCOShz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 14:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXCOShz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 14:37:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:23599 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXCOShy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 14:37:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,289,1170662400"; 
   d="scan'208"; a="213291706:sNHT21814835"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: PCI DAC DMA APIs
Date: Thu, 15 Mar 2007 11:37:44 -0700
User-Agent: KMail/1.9.6
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, davem@redhat.com
References: <45F94C45.76E4.0078.0@novell.com>
In-Reply-To: <45F94C45.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703151137.44538.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2007 5:38 am Jan Beulich wrote:
> While the kernel headers provide for this, there don't appear to be
> any in-tree users (which seems contrary to general Linux policies).
> Would there be objections to remove all of these?

It should be safe to kill them, but I remember arguing with davem about 
this stuff in the past...

Jesse
