Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZIKWDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZIKWDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbZIKWDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:03:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57208 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZIKWDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:03:23 -0400
Date: Fri, 11 Sep 2009 23:03:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, peterz@infradead.org,
       yanmin_zhang@linux.intel.com, torvalds@linux-foundation.org,
       jens.axboe@oracle.com
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
	performance
Message-ID: <20090911220309.GB30989@srcf.ucam.org>
References: <20090911174019.1ed02737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911174019.1ed02737@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you say that a bit more power was used, is that instantaneous power 
draw or total power consumption over the run of the benchmark? I'd have 
expected that completing it 50% faster and then going idle would be a 
win overall.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
