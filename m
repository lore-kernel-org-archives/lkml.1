Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXKTIwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXKTIwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbXKTIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:52:24 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:27239 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbXKTIwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:52:23 -0500
Date: Tue, 20 Nov 2007 09:52:21 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       Swen Schillig <swen@vnet.ibm.com>,
       Ursula Braun <ubraun@linux.vnet.ibm.com>, linux-s390@vger.kernel.org,
       linux390@de.ibm.com
Subject: Re: [PATCH 39/59] drivers/s390: Add missing "space"
Message-ID: <20071120085221.GC7992@osiris.boeblingen.de.ibm.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com> <d9fb5d88f80db783c403b0d7c8e13c1e82c9ad32.1195454435.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9fb5d88f80db783c403b0d7c8e13c1e82c9ad32.1195454435.git.joe@perches.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 05:48:31PM -0800, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/s390/char/monwriter.c |    2 +-
>  drivers/s390/char/vmlogrdr.c  |    2 +-
>  drivers/s390/cio/chsc.c       |    2 +-
>  drivers/s390/net/claw.c       |    2 +-
>  drivers/s390/net/lcs.c        |    2 +-
>  drivers/s390/scsi/zfcp_fsf.c  |   10 +++++-----
>  6 files changed, 10 insertions(+), 10 deletions(-)

Applied as well. Thanks.
