Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbXEQUcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbXEQUcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbXEQUca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:32:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55406 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbXEQUc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:32:28 -0400
Date: Thu, 17 May 2007 21:32:27 +0100 (BST)
From: Artem Bityutskiy <dedekind@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
In-Reply-To: <20070517111838.842a29ca.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705172125080.16443@pentafluge.infradead.org>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron>
 <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron>
 <20070517102931.6bbbad1a.akpm@linux-foundation.org> <1179424006.3642.84.camel@sauron>
 <20070517111838.842a29ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <dedekind@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Andrew Morton wrote:
> Drat, and here was I hoping I'd lured you into implementing the generic
> code.

Well, I am really happy to contribute, but I am not a generic janitor like
Cristoph, who (amaizingly) knows many differet kernel subsystems. I am 
a specific developer and I would rather concentrate on the Flash file 
system I am writing, and this will be my later contribution.

Artem.
