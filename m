Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZEYIFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZEYIFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZEYIFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:05:21 -0400
Received: from mail.tigress.co.uk ([195.172.168.163]:35049 "EHLO
	intgat.tigress.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZEYIFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:05:19 -0400
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 04:05:18 EDT
From: Ron Yorston <rmy@tigress.co.uk>
Message-Id: <200905250748.n4P7mbQS024844@tiffany.internal.tigress.co.uk>
Date: Mon, 25 May 2009 08:48:37 +0100
To: tytso@thunk.org, thomas@glanzmann.de
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: zero out blocks of freed user data for operation a virtual
 machine environment
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
In-Reply-To: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
User-Agent: Heirloom mailx 12.0 3/4/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've written a tool to zero freed blocks in ext2/ext3 filesystems, as well
as a (half-baked) kernel patch.  Details here:

   http://intgat.tigress.co.uk/rmy/uml/sparsify.html

Ron
