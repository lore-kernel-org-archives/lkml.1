Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXH1XOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXH1XOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbXH1XOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:14:08 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:15756 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbXH1XOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fTu4czl98xUvOsdcAXgLZUK1BwGzFwL9gobycssLab/rLJv3x4WpfMmzHmhC/qgDa0ynLlUq0FN5zELnMmdkKGlR7ToWjBSEs4NWL9J3zh6QSZJbdUZQJ0Btrx+ZpMDb9CeN8qgtqvXdsOwqm/z0KTkh7sdqARv7XOAuXg1Bee8=
Message-ID: <6bffcb0e0708281614m74de5beai2778395cb13a90e7@mail.gmail.com>
Date: Wed, 29 Aug 2007 01:14:00 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "=?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?=" <tronic+bpsk@trn.iki.fi>
Subject: Re: 2.6.23-rc3 USB segfaults + urb status -32
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46D0974B.5030806@trn.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46D0974B.5030806@trn.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lasse,

On 25/08/07, Lasse Kärkkäinen <tronic+bpsk@trn.iki.fi> wrote:
> My system is unusably unstable using this kernel.

Does 2.6.22 work fine?

> On last boot it
> started flooding urb status -32 to kernel log at a rate of several
> megabytes per second. Now it printed segfaults before the system had
> finished booting and then some other errors... The full log is here:
>
> I couldn't find information on these bugs. If you need more debug info,
> please contact me. I can also reproduce the errors without the Nvidia
> kernel module,

Yes, please reproduce this error without nvidia binary crap and CC to
linux-usb-devel@lists.sourceforge.net

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
