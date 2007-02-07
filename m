Return-Path: <linux-kernel-owner+w=401wt.eu-S1161478AbXBGXMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161478AbXBGXMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161481AbXBGXMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:12:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:65009 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161478AbXBGXMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:12:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V1w8DhI9499q+4fg+45UGwchgVSzjZ4Oerj1GvkcAF0THB+zkpV5vOIC8YbN5j02Mvu7Wbwy/qMR50vBQ4WfNr+kqRrXOiHXhkvLCEzTKamYZXGcpUKy+4lf5YuA+jykY9kVRS0qgO9TQVP+mUAmeV9f0Y8lfbSionLnjihwqF0=
Message-ID: <6bffcb0e0702071512i2567a2br3a873921b0d3d308@mail.gmail.com>
Date: Thu, 8 Feb 2007 00:12:51 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: mm snapshot broken-out-2007-02-06-16-59.tar.gz uploaded
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070207141532.9c1ac548.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702070059.l170xPY0002614@shell0.pdx.osdl.net>
	 <45CA0065.80705@fr.ibm.com>
	 <6bffcb0e0702071403v767681edk2179fdb968b57e5a@mail.gmail.com>
	 <20070207141532.9c1ac548.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> I copied it to
> http://userweb.kernel.org/~akpm/broken-out-2007-02-06-16-59.tar.gz but
> there's really not much point in using it - it's ancient.

Cedric, here is an updated version
http://www.stardust.webpages.pl/files/mm-snapshot/mm-snapshot-07-02-07-22-21.tar.bz2

Without four patches

#swiotlb-uninlinings.patch
#git-cryptodev-fixup.patch
#add-vm_insert_pfn.patch
#knfsd-fix-a-race-in-closing-nfsd-connections.patch

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
