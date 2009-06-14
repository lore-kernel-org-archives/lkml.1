Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZFNJoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZFNJoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbZFNJn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:43:58 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51687 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZFNJn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:43:57 -0400
Date: Sun, 14 Jun 2009 18:43:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Jie Zhang <jie.zhang@analog.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>
Subject: Re: [PATCH/RFC] FDPIC: add hook for arches to customize program header parsing
Message-ID: <20090614094314.GF832@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier@gentoo.org>, uclinux-dev@uclinux.org,
	linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	David McCullough <davidm@snapgear.com>,
	Greg Ungerer <gerg@uclinux.org>, Jie Zhang <jie.zhang@analog.com>,
	Bernd Schmidt <bernds_cb1@t-online.de>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 09:01:09PM -0400, Mike Frysinger wrote:
> From: Jie Zhang <jie.zhang@analog.com>
> 
> The Blackfin port has custom program header flags/addresses for
> automatically loading regions into the dedicated on-chip SRAM.  So add a
> hook for ports to leverage.
> 
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Bernd Schmidt <bernds_cb1@t-online.de>

Acked-by: Paul Mundt <lethal@linux-sh.org>
