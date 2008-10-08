Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYJHKaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYJHKaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 06:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYJHK3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 06:29:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:55820 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbYJHK3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:29:50 -0400
Subject: Re: linux-firmware patches
From: David Woodhouse <dwmw2@infradead.org>
To: Dave <kilroyd@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48EBAC11.7060803@gmail.com>
References: <48EBAC11.7060803@gmail.com>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 11:29:46 +0100
Message-Id: <1223461786.20499.29.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 19:36 +0100, Dave wrote:
> Should patches to add firmware to the linux-firmware tree (and not the
> main kernel) be sent to linux-kernel, or somewhere else? It wasn't
> mentioned in the [ANNOUNCE]*, and I haven't been able to find an
> example on list.
> 
> Just wanted to check before posting an 80k patch consisting of non-GPL
> binary files.

Patches with binary files are going to be hard -- probably best just to
commit to a git tree and ask me to pull. Or mail the files separately,
with the changes to the WHENCE file as a separate patch.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



