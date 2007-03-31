Return-Path: <linux-kernel-owner+w=401wt.eu-S1750717AbXCaHRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750717AbXCaHRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 03:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXCaHRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 03:17:33 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:42193 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750717AbXCaHRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 03:17:32 -0400
Date: Sat, 31 Mar 2007 09:12:20 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
Message-ID: <20070331071220.GA26910@aitel.hist.no>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330010559.2a232d9a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A new error for me:

loading 2.6.21rc5mm3
Bios data check successful
Destination address not 2M aligned
 -- System halted


This is using the same lilo that loads 2.6.18rc5mm1 fine.
x86-64

Helge Hafting
