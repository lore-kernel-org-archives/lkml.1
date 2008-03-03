Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbYCCKll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbYCCKll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYCCKld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:41:33 -0500
Received: from eir.is.scarlet.be ([193.74.71.27]:37860 "EHLO eir.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYCCKlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:41:32 -0500
Date: Mon,  3 Mar 2008 11:36:21 +0100
Message-Id: <JX5HGL$BEF7E287D07253279B235998ACF88988@scarlet.be>
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "rubisher" <rubisher@scarlet.be>
To: "kyle" <kyle@mcmartin.ca>
Cc: "fujita\.tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-parisc" <linux-parisc@vger.kernel.org>, "tomof" <tomof@acm.org>,
       "kyle" <kyle@parisc-linux.org>, "matthew" <matthew@wil.cx>,
       "grundler" <grundler@parisc-linux.org>,
       "akpm" <akpm@linux-foundation.org>, "rubisher" <rubisher@scarlet.be>
X-XaM3-API-Version: 4.1 (B54)
X-type: 0
X-SenderIP: 57.67.177.33
X-DCC-scarlet.be-Metrics: eir; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Mar 02, 2008 at 03:10:25PM +0900, FUJITA Tomonori wrote:
> > This patchset is another sequel to my patchset to fix iommu segment
> > boundary problems, IOMMUs allocate memory areas without considering a
> > low level driver's segment boundary limits:
> > 
> > http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html
> > 
> 
> This looks fine. Are you able to test this? If not, we can set you up
> with an account on a machine with remote console and all that jazz, if
> you'd like to.
> 
> cheers, Kyle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Dear *,

I have access to 3 kind of boxes which needed one of those drivers: a b2k and
mainly a c110 and a d380 for which I hope a lot of this patch ;-)

I will so try the patch asap and let you know the results.

hth,
    r.

---
Scarlet One, ADSL 6 Mbps + Telephone, from EUR 29,95...
http://www.scarlet.be/

