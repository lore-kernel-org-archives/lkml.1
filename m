Return-Path: <linux-kernel-owner+w=401wt.eu-S1423063AbXBBBi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423063AbXBBBi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 20:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423064AbXBBBi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 20:38:57 -0500
Received: from smtp-out.google.com ([216.239.45.13]:42340 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423063AbXBBBi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 20:38:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=x37Nhrn0SAraV2ztyNTYFMMtUKSyAplHb3Vn+ohPJSIYIEeu9Nerr4PjnyWgcsVJ4
	LWzGCk5p8C/kRFQJyEigw==
Message-ID: <45C2960B.9070907@google.com>
Date: Thu, 01 Feb 2007 17:38:19 -0800
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061117)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Christoph -- has anything come of resolving the NFS / OOM 
concerns that Andrew Morton expressed concerning the patch? I'd be happy 
to see some progress on getting this patch (i.e. the one you posted on 
1/23) through.

    Thanks,
    -- Ethan

