Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbYDGIk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbYDGIk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYDGIkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:40:47 -0400
Received: from lazybastard.de ([212.112.238.170]:54799 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYDGIkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:40:46 -0400
Date: Mon, 7 Apr 2008 10:40:38 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [patch 1/15] Makefiles and Kconfig
Message-ID: <20080407084037.GC22431@logfs.org>
References: <20080401181308.512473173@logfs.org> <20080401181332.853833001@logfs.org> <200804071028.58362.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804071028.58362.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 April 2008 10:28:58 +0200, Christian Borntraeger wrote:
> 
> can you make the Kconfig/Makefile changes the last patch? This will help git 
> bisect. 

I won't merge 15 patches anyway.  The splitup is for review purposes
only. ;)

Jörn

-- 
Sometimes, asking the right question is already the answer.
-- Unknown
