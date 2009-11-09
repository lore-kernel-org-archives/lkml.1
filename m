Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZKITub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZKITub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 14:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZKITua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 14:50:30 -0500
Received: from [95.166.99.235] ([95.166.99.235]:58160 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbZKITua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 14:50:30 -0500
Date: Mon, 9 Nov 2009 20:50:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Karel Zak <kzak@redhat.com>
Cc: Andries Brouwer <aeb@cwi.nl>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] partitions: use sector size for EFI GPT
Message-ID: <20091109195034.GA8742@kernel.dk>
References: <1256294176-32113-1-git-send-email-kzak@redhat.com> <20091109130827.GO5610@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109130827.GO5610@nb.net.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09 2009, Karel Zak wrote:
> On Fri, Oct 23, 2009 at 12:36:15PM +0200, Karel Zak wrote:
> > Currently, kernel uses strictly 512-byte sectors for EFI GPT parsing.
> > That's wrong.
> 
>  Ping? Does anyone care about new disks with non-512byte sectors? 
>  (or fs/partitions is unmaintained area? ;-)

Can you repost them, please? I don't seem to have them, most likely got
lost in the jls2009/ks travel schedule.

-- 
Jens Axboe

