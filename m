Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbXKTHsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbXKTHsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbXKTHsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:48:37 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2595 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbXKTHsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:48:37 -0500
Subject: Re: [PATCH 06/59] arch/sparc: Add missing "space"
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org
In-Reply-To: <20071119.234500.127324508.davem@davemloft.net>
References: <1195523331-15303-6-git-send-email-joe@perches.com>
	 <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
	 <1195523331-15303-7-git-send-email-joe@perches.com>
	 <20071119.234500.127324508.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 23:48:36 -0800
Message-Id: <1195544916.4675.117.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 23:45 -0800, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Mon, 19 Nov 2007 17:47:58 -0800
> > Signed-off-by: Joe Perches <joe@perches.com>
> Please check your patches, for trailing white "space".
> Adds trailing whitespace.
> diff:10:		prom_printf("PCIC: Error, cannot map " 
> Adds trailing whitespace.
> diff:19:		prom_printf("PCIC: Error, cannot map " 
> warning: 2 lines add whitespace errors.
> I've fixed it up this time.

It doesn't add whitespace, but it does keep the trailing
whitespace that's already there.

cheers, Joe

