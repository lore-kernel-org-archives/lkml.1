Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbYKGOMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbYKGOMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYKGOMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:12:15 -0500
Received: from mail.tpi.com ([198.107.51.143]:3879 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYKGOMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:12:15 -0500
Message-ID: <49144CB8.8070604@tpi.com>
Date: Fri, 07 Nov 2008 07:12:08 -0700
From: Tim Gardner <tcanonical@tpi.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Stillwell, Bryan" <bryan.stillwell@hp.com>
CC: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       ISS StorageDev <iss_storagedev@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cciss: firmware version is invalid
References: <20081106201204.9C2AEF8A65@sepang.rtg.net> <1226005890.13433.390.camel@aki.stillwell>
In-Reply-To: <1226005890.13433.390.camel@aki.stillwell>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stillwell, Bryan wrote:
> Tim,
> 
> Thanks for getting this merged, but I believe this patch is preferred
> over the original one I attached:
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch
> 
> The reason for this according to Mike Miller is: "The first fix could be
> called anytime something changed on the controller such as number of
> logical volumes, etc.  This patch will get called only once for each
> controller."
> 
> Thanks,
> Bryan

applied


-- 
Tim Gardner tim.gardner@canonical.com
