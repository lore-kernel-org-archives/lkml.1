Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbXLLAGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbXLLAGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbXLLAGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:06:34 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:60865 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbXLLAGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:06:33 -0500
Date: Wed, 12 Dec 2007 00:59:47 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: sorbica@icplus.com.tw, jesse@icplus.com.tw, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/ipg.c: add __devexit annotation
Message-ID: <20071211235947.GA30456@electric-eye.fr.zoreil.com>
References: <20071211222030.GD14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211222030.GD14204@stusta.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> :
> ipg_remove() can become __devexit.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

I'll add it to the pending ipg queue.

-- 
Ueimor
