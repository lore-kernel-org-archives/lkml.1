Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbXKTBMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbXKTBMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXKTBMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:12:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbXKTBMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:12:30 -0500
Date: Tue, 20 Nov 2007 02:12:21 +0100
From: Karel Zak <kzak@redhat.com>
To: vince kim <vince.kim@access-company.com>
Cc: linux-kernel@vger.kernel.org, "Richard Purdie [rpurdie"@openedhand.com
Subject: Re: [PATCH 2/2 ] Add support LZO in mkcramfs tool
Message-ID: <20071120011221.GK11527@petra.dvoda.cz>
References: <1193441160.17726.18.camel@vince-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193441160.17726.18.camel@vince-desktop>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 04:26:00PM -0700, vince kim wrote:
> This patch adds support LZO compression in mkcramfs tool, so it can
> generate a cramfs image compress with LZO.
> To compile mkcramfs with this patch, liblzo2-dev package must be
> installed.
> 
> The patch is created against mkcramfs tool ver 1.1 which can be found
> at:
> http://sourceforge.net/projects/cramfs/

 Ah...

    Latest     1.1 Notes (2002-02-24 00:00)

 ...seems like a zombie project.


 I think many Linux distributions use mkfs.cramfs from
 util-linux[-ng].

 git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
