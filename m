Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbXCQQcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbXCQQcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 12:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXCQQcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 12:32:36 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:36985 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbXCQQcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 12:32:36 -0400
Date: Sat, 17 Mar 2007 12:31:03 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, matthew@wil.cx,
       kyle@parisc-linux.org, grundler@parisc-linux.org
Subject: Re: [PATCH] parisc: convert /proc/gsc/pcxl_dma to seq_file
Message-ID: <20070317163103.GC10950@athena.road.mcmartin.ca>
References: <20070317162827.GA5327@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070317162827.GA5327@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 07:28:27PM +0300, Alexey Dobriyan wrote:
> As side effect, remove one more ->get_info user and a novel approach of content
> generation:
> 

snprintf? We don't need no stinkin' snprintf.

applied.
