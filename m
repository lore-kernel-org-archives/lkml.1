Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYAHEC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYAHEC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 23:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYAHECs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 23:02:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:41503 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbYAHECr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 23:02:47 -0500
Subject: Re: [PATCH][POWERPC] Workaround for iommu page alignment (#2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Olof Johansson <olof@lixom.net>
Cc: Paul Mackerras <paulus@samba.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080108034824.GA7983@lixom.net>
References: <1199742359.6734.14.camel@pasglop>
	 <1199748862.6734.20.camel@pasglop>  <20080108034824.GA7983@lixom.net>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 15:02:24 +1100
Message-Id: <1199764944.6734.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And sloppy of me to not catch it. Anyway:
> 
> Acked-by: Olof Johansson <olof@lixom.net>
> 
> I wonder how long until there's a device that has some other < PAGE_SIZE
> alignment bug^Wrequirement that we'll need to meet too. :(

Yeah, it's a worry...

Ben.


