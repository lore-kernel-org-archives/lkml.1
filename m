Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbYD1JgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbYD1JgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbYD1JgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:36:12 -0400
Received: from oss.sgi.com ([192.48.170.157]:57136 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764064AbYD1JgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:36:12 -0400
Date: Mon, 28 Apr 2008 10:35:51 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] asm-mips/mach-ip27/topology.h must #include
	<asm-generic/topology.h>
Message-ID: <20080428093550.GB18190@linux-mips.org>
References: <20080423155559.GR28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423155559.GR28933@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 06:55:59PM +0300, Adrian Bunk wrote:

> Subject: [2.6 patch] asm-mips/mach-ip27/topology.h must #include
> 	<asm-generic/topology.h>

Thanks, applied.

  Ralf
