Return-Path: <linux-kernel-owner+w=401wt.eu-S934407AbXGWTnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407AbXGWTnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764467AbXGWTnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:43:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55329 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762979AbXGWTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:43:34 -0400
Date: Mon, 23 Jul 2007 20:43:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] the next round of scheduled OSS code removal
Message-ID: <20070723194333.GM21668@ftp.linux.org.uk>
References: <20070723193339.GQ26212@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723193339.GQ26212@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 09:33:39PM +0200, Adrian Bunk wrote:
> This patch contains the next round of scheduled OSS code removal.

Er...  There are e.g. m68k dmasound drivers; with dmasound_core gone
they won't survive, AFAICS...
