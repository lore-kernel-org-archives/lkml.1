Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752427AbYLRTXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbYLRTXU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYLRTXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:23:06 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:38312 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYLRTXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:23:05 -0500
Date: Thu, 18 Dec 2008 20:24:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Nick Andrew <nick@nick-andrew.net>, Matthew Wilcox <matthew@wil.cx>,
        Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in header files
Message-ID: <20081218192433.GA15206@uranus.ravnborg.org>
References: <20081213222259.GB29080@uranus.ravnborg.org> <20081216115249.GA3901@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216115249.GA3901@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This one is probably a bit too noisy? But if we can eliminate the existing
> cycles, it would be nice, I agree. Thanks for the feedback! :)

Applied to kbuild-next.

	Sam
