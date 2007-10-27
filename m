Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbXJ0Uru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbXJ0Uru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 16:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbXJ0Url
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:47:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48121 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXJ0Urk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:47:40 -0400
Date: Sat, 27 Oct 2007 21:47:35 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/45] AppArmor security module overview
Message-ID: <20071027204735.GA350@infradead.org>
References: <20071026064024.243943043@suse.de> <20071026073721.618b4778@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026073721.618b4778@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 07:37:21AM -0700, Arjan van de Ven wrote:
> before going into the LSM / security side of things, I'd like to get
> the VFS guys to look at your VFS interaction code.

It's been NACKed a few times, and just reposting it won't help.

