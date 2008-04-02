Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYDBTLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYDBTLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbYDBTLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:11:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:19837 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbYDBTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=G/X3ebpHvEdauNHWXyYo1NsAZ+CRnl0PLnzr5Tzm+UcHmnvBnJI6T+lshaoHH2Ipeja0y0wWON43SXg51AWYVbryqsArUOS4eQeSVjDniRs7b56sZGGyBaeaIuWDyHsV6/ddItSVbGTBbNfJvEpm1lyheUD+u0Uxc71W1Ouodp8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6.25 patch] ide-pnp.c: add MODULE_LICENSE
Date: Wed, 2 Apr 2008 20:53:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
References: <20080331090738.GE28445@cs181133002.pp.htv.fi>
In-Reply-To: <20080331090738.GE28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804022053.34267.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008, Adrian Bunk wrote:
> Now that it's in an own module it needs a MODULE_LICENSE.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied all twelve "MODULE_LICENSE" patches

Thanks,
Bart
