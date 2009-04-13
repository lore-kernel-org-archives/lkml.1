Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZDMKEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZDMKEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 06:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbZDMKEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 06:04:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59139 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbZDMKEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 06:04:44 -0400
Date: Mon, 13 Apr 2009 11:04:40 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: How movable is zone movable?
Message-ID: <20090413100440.GB15333@csn.ul.ie>
References: <200904121129.09851.edt@aei.ca> <20090413095924.GA15333@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090413095924.GA15333@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 10:59:25AM +0100, Mel Gorman wrote:
> > # huge_pages with movablecore set to 3G
> 
> How big did you make the movable zone and what is the hugepage size?

Scratch that question, I missed you said it was 3G. Are pages being
mlocked()?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
