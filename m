Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbYBQUgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbYBQUgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYBQUg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:36:28 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:44206 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYBQUg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:36:27 -0500
Date: Sun, 17 Feb 2008 21:36:25 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: getting uninterruptible sleep processes after upgrade from
 2.6.20.20 to 2.6.24.2
In-Reply-To: <47B892B9.7060205@allied-internet.ag>
Message-ID: <alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de>
References: <47B892B9.7060205@allied-internet.ag>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, allied internet ag- Stefan Priebe wrote:
> One week ago we upgraded about 300 servers from 2.6.20.20 to 2.6.24.2.

Did you test with *one* server before upgrading all 300? If not, please do 
and try to upgrade in smaller steps, e.g. 2.6.20->2.6.21 and see when it 
breaks. Add a few *DEBUG .config options, they may help narrowing 
down the problem...

C.
-- 
BOFH excuse #405:

Sysadmins unavailable because they are in a meeting talking about why they are unavailable so much.
