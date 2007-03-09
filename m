Return-Path: <linux-kernel-owner+w=401wt.eu-S1767188AbXCILRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767188AbXCILRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767193AbXCILRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:17:32 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:49791 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767188AbXCILRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:17:32 -0500
Message-ID: <45F14232.5060703@s5r6.in-berlin.de>
Date: Fri, 09 Mar 2007 12:17:06 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: any thoughts yet on a "generic" ioctl.h?
References: <Pine.LNX.4.64.0703081556260.9349@CPE00045a9c397f-CM001225dbafb6> <45F0D798.4050602@s5r6.in-berlin.de> <Pine.LNX.4.64.0703090450160.30726@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0703090450160.30726@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> each simplification could be submitted as
> a separate arch-specific patch, as many things are.
> 
> i was more asking about the *philosophy* of that patch,

The justification of this initial patch is more obvious if followed up
by those subsequent patches which make use of the initial one.
-- 
Stefan Richter
-=====-=-=== --== --===
http://arcgraph.de/sr/
