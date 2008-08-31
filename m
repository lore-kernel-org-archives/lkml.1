Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYHaOyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYHaOyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYHaOyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:54:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38072 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbYHaOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:54:04 -0400
Message-ID: <48BAAFC3.3020901@cs.helsinki.fi>
Date: Sun, 31 Aug 2008 17:50:43 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: akpm@linux-foundation.org, Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 3/3] dentries: dentry defragmentation
References: <20080825212035.861870487@quilx.com> <20080825212053.734467711@quilx.com>
In-Reply-To: <20080825212053.734467711@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> The dentry pruning for unused entries works in a straightforward way. It
> could be made more aggressive if one would actually move dentries instead
> of just reclaiming them.
> 
> Cc: Alexander Viro <viro@ftp.linux.org.uk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Applied, thanks!
