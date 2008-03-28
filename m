Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYC1SIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYC1SIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYC1SIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:08:19 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:46101 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbYC1SIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:08:19 -0400
Message-ID: <47ED33C6.3090202@freescale.com>
Date: Fri, 28 Mar 2008 13:07:02 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: York Sun <yorksun@freescale.com>, linux-fbdev-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/2 v4] Driver for Freescale 8610 and 5121 DIU
References: <12066720572512-git-send-email-yorksun@freescale.com> <12066720572314-git-send-email-yorksun@freescale.com> <47ED2B35.4030601@freescale.com>
In-Reply-To: <47ED2B35.4030601@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:

> ...but not anywhere else.  All user pointers should have a __user 
> annotation.

Even in a typecast?

-- 
Timur Tabi
Linux kernel developer at Freescale
