Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYGVWS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYGVWS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbYGVWSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:18:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:30134 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365AbYGVWSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,233,1215414000"; 
   d="scan'208";a="600097399"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] pci: proc.c sparse endian annotations
Date: Tue, 22 Jul 2008 15:18:10 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1216335450.6029.45.camel@brick> <200807221437.01847.jesse.barnes@intel.com> <1216762847.13328.19.camel@brick>
In-Reply-To: <1216762847.13328.19.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221518.10989.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2008 2:40 pm Harvey Harrison wrote:
> drivers/pci/proc.c:91:3: warning: cast from restricted __le16
> drivers/pci/proc.c:100:3: warning: cast from restricted __le32
> drivers/pci/proc.c:109:3: warning: cast from restricted __le16
> drivers/pci/proc.c:161:40: warning: cast to restricted __le16
> drivers/pci/proc.c:170:41: warning: cast to restricted __le32
> drivers/pci/proc.c:179:40: warning: cast to restricted __le16
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Silly me.  I thought it was your mailer corrupting things but of course it was 
the Exchange server for my @intel.com address.  I have no idea why Exchange 
finds text so difficult to handle text without molesting it, but there you 
go.  I'll grab your patch from my lkml mailbox, which necessarily gets routed 
to my virtuousgeek.org addr.

Thanks,
Jesse
