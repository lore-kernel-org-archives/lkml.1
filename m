Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbXJINcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbXJINcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 09:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXJINcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 09:32:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:1048 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXJINci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 09:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=drxIrOiehE9QCSfHi8m9CpzDVji+H1Le4Tmm6jwO6umioVq9EjPeZtkmeRGzmFl7IuLnmZlI5R8rCXcW5rHLDK3CDZ6aKXkidMDfzCA4dDVWw/BlDgWcsJDmN0TiCJD3bn6ARgFqbQh5XYjbMnZ+K2L+zlX6RxeN/74XWLW8mp0=
Date: Tue, 9 Oct 2007 15:32:26 +0200
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] fix wrong /proc/cpuinfo output
Message-ID: <20071009133226.GC4245@Ahmed>
References: <20071009104321.GA32272@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009104321.GA32272@APFDCB5C>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 07:43:21PM +0900, Akinobu Mita wrote:
> This patch fixes the problem introduced by:
> http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
> 

Link is dead, same patch in lkml.org:

http://lkml.org/lkml/2007/9/24/394

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
