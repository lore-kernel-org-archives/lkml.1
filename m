Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbYEUTRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbYEUTRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbYEUTRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:17:13 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:56437 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755060AbYEUTRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:17:12 -0400
Date: Wed, 21 May 2008 20:53:06 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Emmanuel Colbus <emmanuel.colbus@ovh.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][TRIVIAL] r8169.c : fix misleading comment
Message-ID: <20080521185306.GA9320@electric-eye.fr.zoreil.com>
References: <48342CDF.1040304@ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48342CDF.1040304@ovh.net>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emmanuel Colbus <emmanuel.colbus@ovh.net> :
> Calling "PCI base addr 1" something that can actually lie at 
> PCI_BASE_ADDR_2 is misleading. Patch follows.
>
> signed-off-by : emmanuel colbus <emmanuel.colbus@ovh.net>

I do not approve:
- the patch does not follow the comment style of the driver
- the comment should be removed, not silly augmented

-- 
Ueimor
