Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbXHPFYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbXHPFYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 01:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbXHPFXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 01:23:54 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:63155 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbXHPFXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 01:23:53 -0400
Date: Thu, 16 Aug 2007 15:12:56 +1000
From: David Gibson <dwg@au1.ibm.com>
To: Adam Litke <agl@us.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>, linuxppc-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Documentation] Page Table Layout diagrams
Message-ID: <20070816051256.GF3540@localhost.localdomain>
Mail-Followup-To: Adam Litke <agl@us.ibm.com>,
	linux-mm <linux-mm@kvack.org>, linuxppc-dev@ozlabs.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1186598865.23817.76.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186598865.23817.76.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 01:47:45PM -0500, Adam Litke wrote:
> Hello all.  In an effort to understand how the page tables are laid out
> across various architectures I put together some diagrams.  I have
> posted them on the linux-mm wiki: http://linux-mm.org/PageTableStructure
> and I hope they will be useful to others.  
> 
> Just to make sure I am not spreading misinformation, could a few of you
> experts take a quick look at the three diagrams I've got finished so far
> and point out any errors I have made?  Thanks.

Nice.  Didn't spot any innaccuracies.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
