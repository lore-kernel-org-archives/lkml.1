Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbXKMAxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbXKMAxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXKMAxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:53:46 -0500
Received: from mx1.suse.de ([195.135.220.2]:54221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002AbXKMAxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:53:45 -0500
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: x86_64: Make sparsemem/vmemmap the default memory model
Date: Tue, 13 Nov 2007 01:49:54 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>
References: <Pine.LNX.4.64.0711121549370.29178@schroedinger.engr.sgi.com> <200711130059.34346.ak@suse.de> <Pine.LNX.4.64.0711121615120.29328@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711121615120.29328@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711130149.54852.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmmm... More memory free? How did that happen? More pages cached for some
> reason. The total available memory is increased by 8k.

Nice. Looks all reasonable. Thanks for the numbers.

-Andi
