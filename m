Return-Path: <linux-kernel-owner+w=401wt.eu-S1763571AbYB1VBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763571AbYB1VBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760070AbYB1VBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:01:32 -0500
Received: from outbound-mail-07.bluehost.com ([69.89.17.207]:55680 "HELO
	outbound-mail-07.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752639AbYB1VBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:01:32 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: akepner@sgi.com
Subject: Re: [PATCH 0/3 v3] dma: dma_{un}map_{single|sg}_attrs() interface
Date: Thu, 28 Feb 2008 12:05:27 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Tony Luck <tony.luck@intel.com>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org
References: <20080228032351.GR11012@sgi.com>
In-Reply-To: <20080228032351.GR11012@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802281205.27831.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 209.216.177.132 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 27, 2008 7:23 pm akepner@sgi.com wrote:
> v2->v3 changes:
> mainly cosmetic changes to make checkpatch a little happier -
> trailing whitespace, long lines.... Also made dma_set_attr() a
> no-op inline func when ARCH_USES_DMA_ATTRS is not defined instead
> of a macro.
>
> I'd like to get this one queued up for 2.6.26.

Hey Arthur, the patch set looks nice to me.  You can add my

Acked-by:  Jesse Barnes <jesse.barnes@intel.com>

to the series if you like.
