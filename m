Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbXHSWth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbXHSWth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXHSWt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:49:29 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1595 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbXHSWt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:49:28 -0400
Subject: Re: convert #include "linux/..." to #include <linux/...> [PATCH]s
	follow
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20070819224425.GU21089@ftp.linux.org.uk>
References: <1187561864.4200.136.camel@localhost>
	 <Pine.LNX.4.64.0708200031560.19577@fbirervta.pbzchgretzou.qr>
	 <20070819224425.GU21089@ftp.linux.org.uk>
Content-Type: text/plain
Date: Sun, 19 Aug 2007 15:49:16 -0700
Message-Id: <1187563756.4200.167.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-19 at 23:44 +0100, Al Viro wrote:
> Except that some instances are legitimate (e.g. there was a bunch in
> arch/um, IIRC)...

I guess it's a good thing that vger seems to have rejected
that 140KB patch I sent against arch/um and include/asm-um.

cheers, Joe

