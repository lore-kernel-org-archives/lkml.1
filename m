Return-Path: <linux-kernel-owner+w=401wt.eu-S935615AbXLNBEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935615AbXLNBEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 20:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935447AbXLNBDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 20:03:48 -0500
Received: from thunk.org ([69.25.196.29]:60950 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935358AbXLNBDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 20:03:46 -0500
Date: Thu, 13 Dec 2007 20:03:03 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: sct@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] ext4: remove unused code from ext4_find_entry()
Message-ID: <20071214010303.GA17344@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mariusz Kozlowski <m.kozlowski@tuxland.pl>, sct@redhat.com,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
References: <200712122246.41284.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712122246.41284.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 10:46:40PM +0100, Mariusz Kozlowski wrote:
> Hello,
> 
> 	The unused code found in ext3_find_entry() is also present (and still unused)
> in the ext4_find_entry() code. This patch removes it. Compile tested only.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks, this will be in the next ext4 patchset.

	     	     	    	 - Ted
