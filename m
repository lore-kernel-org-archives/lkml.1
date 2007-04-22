Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXDVWaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXDVWaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 18:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXDVWaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 18:30:23 -0400
Received: from smtp2.cc.ksu.edu ([129.130.7.16]:39420 "EHLO smtp2.cc.ksu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbXDVWaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 18:30:22 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2007 18:30:22 EDT
Message-ID: <462B8D0C.7020509@ksu.edu>
Date: Sun, 22 Apr 2007 11:27:56 -0500
From: Amit Gud <gud@ksu.edu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Karuna sagar K <karunasagark@gmail.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ChunkFS - measuring cross-chunk references
References: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com>
In-Reply-To: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karuna sagar K wrote:
> Hi,
> 
> The attached code contains program to estimate the cross-chunk
> references for ChunkFS file system (idea from Valh). Below are the
> results:
> 

Nice to see some numbers! But would be really nice to know:

- what the chunk size is
- how the files were created or, more vaguely, how 'aged' the fs is
- what is the chunk allocation algorithm


Best,
AG
-- 
May the source be with you.
http://www.cis.ksu.edu/~gud

