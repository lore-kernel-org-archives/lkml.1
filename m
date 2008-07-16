Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYGPIRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYGPIRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYGPIQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:16:45 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:13590 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbYGPIQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:16:44 -0400
Date: Wed, 16 Jul 2008 10:15:27 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] chsc headers userspace cleanup
Message-ID: <20080716081527.GA4869@osiris.boeblingen.de.ibm.com>
References: <20080715125817.GB24533@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715125817.GB24533@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 03:58:18PM +0300, Adrian Bunk wrote:
> Kernel headers shouldn't expose functions to userspace.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Makes sense. Applied -- Thanks.

> BTW: For compile-testing my patches it would be nice if s390 had
>      more defconfigs (e.g. also a non-64bit one).

Yes, will consider that ;)
