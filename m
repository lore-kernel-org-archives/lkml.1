Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZBDKeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZBDKeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZBDKei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:34:38 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:34674 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbZBDKeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:34:37 -0500
Date: Wed, 4 Feb 2009 13:34:44 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: fixup BUG macro
Message-ID: <20090204103444.GA31229@jurassic.park.msu.ru>
References: <20090204101652.GA11007@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204101652.GA11007@x200.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 01:16:52PM +0300, Alexey Dobriyan wrote:
> Do usual do {} while (0) dance, otherwise
> 
> fs/gfs2/util.c:99: error: expected expression before 'else'
> drivers/scsi/lpfc/lpfc_sli.c:363: error: expected expression before 'else'
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.
