Return-Path: <linux-kernel-owner+w=401wt.eu-S935355AbZLGPhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355AbZLGPhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935346AbZLGPhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:37:37 -0500
Received: from thunk.org ([69.25.196.29]:43852 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577AbZLGPhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:37:36 -0500
Date: Mon, 7 Dec 2009 10:37:28 -0500
From: tytso@mit.edu
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext3: PTR_ERR return of wrong pointer in
 setup_new_group_blocks()
Message-ID: <20091207153728.GC27692@thunk.org>
Mail-Followup-To: tytso@mit.edu, Roel Kluin <roel.kluin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <4B1D0813.4070502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D0813.4070502@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 02:50:11PM +0100, Roel Kluin wrote:
> Return the PTR_ERR of the correct pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks for pointing this out!  I've added a similar patch for ext4 in
the patch queue.

					- Ted
