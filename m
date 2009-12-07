Return-Path: <linux-kernel-owner+w=401wt.eu-S935366AbZLGPhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935366AbZLGPhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935208AbZLGPht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:37:49 -0500
Received: from thunk.org ([69.25.196.29]:43857 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935358AbZLGPhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:37:45 -0500
Date: Mon, 7 Dec 2009 10:37:50 -0500
From: tytso@mit.edu
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: PTR_ERR return of wrong pointer in
 setup_new_group_blocks()
Message-ID: <20091207153750.GD27692@thunk.org>
Mail-Followup-To: tytso@mit.edu, Roel Kluin <roel.kluin@gmail.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4B1D0873.90004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D0873.90004@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 02:51:47PM +0100, Roel Kluin wrote:
> Return the PTR_ERR of the correct pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
