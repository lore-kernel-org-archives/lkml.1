Return-Path: <linux-kernel-owner+w=401wt.eu-S1763157AbXJXRIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763157AbXJXRIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbXJXRH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:07:59 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:13405 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761994AbXJXRH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:07:57 -0400
Date: Wed, 24 Oct 2007 18:07:29 +0100
From: Andy Whitcroft <andyw@uk.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Andy Whitcroft <andyw@uk.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-git18: ext2_check_page: bad entry in directory
Message-ID: <20071024170729.GC23139@shadowen.org>
References: <20071024131540.GV32058@shadowen.org> <20071024135900.GC2652@duck.suse.cz> <20071024143308.GA23139@shadowen.org> <20071024150302.GD2652@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024150302.GD2652@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 05:03:03PM +0200, Jan Kara wrote:

> e2image -r /dev/sda1 - | gzip -dc root-image.gz

This thing is 27MB, I'll try and find some space to hold it and
let you know where it is offlist.

-apw
