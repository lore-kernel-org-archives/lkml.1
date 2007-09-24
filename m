Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbXIXRcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbXIXRcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbXIXRcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:32:25 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46450 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756798AbXIXRcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:32:24 -0400
Date: Mon, 24 Sep 2007 13:32:23 -0400
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       jeff@garzik.org, mchan@broadcom.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Message-ID: <20070924173223.GL5386@csclub.uwaterloo.ca>
References: <200709211201.24475.vda.linux@googlemail.com> <200709211905.23946.vda.linux@googlemail.com> <p73ps0b93ph.fsf@bingen.suse.de> <200709212337.53043.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709212337.53043.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 11:37:52PM +0100, Denys Vlasenko wrote:
> But I compile net/* into bzImage. I like netbooting :)

Isn't it possible to netboot with an initramfs image?  I am pretty sure
I have seen some systems do exactly that.

--
Len Sorensen
