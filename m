Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbZG3JKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbZG3JKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZG3JKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:10:04 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52363 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZG3JKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:10:03 -0400
Date: Thu, 30 Jul 2009 11:10:02 +0200
From: Andreas Mohr <andim2@users.sourceforge.net>
To: Andreas Mohr <andi@lisas.de>
Cc: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Roberto Oppedisano <roppedisano@infracomspa.it>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: Re: drm:radeon_cp_idle/reset error storm, console lockup (-rc4 git)
Message-ID: <20090730091002.GA17934@rhlx01.hs-esslingen.de>
Reply-To: andi@lisas.de
References: <alpine.DEB.0.82.0809090914300.1221@skynet.skynet.ie> <20090730090005.GA4885@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730090005.GA4885@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 30, 2009 at 11:00:05AM +0200, Andreas Mohr wrote:
> Hi,
> 
> encountered this problem myself, was able to regain access only via
> remote login, then saw tons of (ratelimited)

...proceeded to kill -9 the X server to try to restart things,
and the result was a nice box taken off anything whatsoever (==> paperweight).
(it's still doing _something_ however, since there seems to be moderate disk
access, but...)

Andreas Mohr
