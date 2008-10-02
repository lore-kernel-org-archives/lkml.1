Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYJBKsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYJBKsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 06:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYJBKsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 06:48:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52692 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYJBKsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 06:48:22 -0400
Date: Thu, 2 Oct 2008 12:48:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bio.h: Remove unused conditional code
Message-ID: <20081002104802.GE19428@kernel.dk>
References: <1222481368-15221-1-git-send-email-albertito@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222481368-15221-1-git-send-email-albertito@blitiri.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26 2008, Alberto Bertogli wrote:
> The whole bio_integrity() definition is inside an #ifdef
> CONFIG_BLK_DEV_INTEGRITY, there's no need for the conditional code.

Applied

-- 
Jens Axboe

