Return-Path: <linux-kernel-owner+w=401wt.eu-S933547AbZINXJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbZINXJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 19:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933505AbZINXJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 19:09:21 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:51444 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933504AbZINXJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 19:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uT8+o0LYHCafcX8Wgy6ijjLX7aU+eNoDF8SwsBqSevuomB6DeS1GBBFw3Dtc7xMG4M
         dxIdlDWDQBuizez/It0tWFlx4XE+Km5YXst1w56zMWlSguVEgavgH50Usf+BKfCFiD9m
         ZWxWPh/FsydzZSatsSReLJln8fTC7Bl9vN67k=
Date: Mon, 14 Sep 2009 16:09:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] Input: ad7879: add support for AD7889
Message-ID: <20090914230918.GA31662@core.coreip.homeip.net>
References: <1252966772-27645-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252966772-27645-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 06:19:32PM -0400, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> The AD7889 is a new part but 100% software compatible with the AD7879, so
> add it to the id_table and help text.
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied, thank you Mike.

-- 
Dmitry
