Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYIJPA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYIJPA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYIJPAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:00:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56718 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbYIJPAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:00:18 -0400
Message-ID: <48C7E044.2050406@redhat.com>
Date: Wed, 10 Sep 2008 09:57:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <20080910112709.GA11742@infradead.org> <20080910114011.GB3757@localhost.localdomain> <20080910114042.GA15996@infradead.org> <20080910114923.GC3757@localhost.localdomain> <48C7CDF4.2020206@redhat.com> <20080910134700.GI3757@localhost.localdomain>
In-Reply-To: <20080910134700.GI3757@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> On Wed, Sep 10, 2008 at 08:39:00AM -0500, Eric Sandeen wrote:

>> I think it does not.
> 
> It does:
> 
> $ grep unifdef-y include/linux/Kbuild | grep ext2
> unifdef-y += ext2_fs.h

Oops, I stand corrected :)

-Eric
