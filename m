Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZJ2NgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZJ2NgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZJ2NgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:36:21 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:9068 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbZJ2NgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:36:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=T42CSxEGAnVLV7QOWG2g6/v8xEGiGe4xzJwzWQgICMtqUTKT3zyC7cJRYzWi5NV2Sf
         O6EM05HB09i08vuD0Iyee7sWFplq153yVwYEc5WYTWOnflGqZ5bNAfJ2X63QRP3IJsq+
         aBg9g1auDPz6Sxn6LI4K/8efwS04u6SU6Vblk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Thu, 29 Oct 2009 14:35:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com
References: <200910291212.41656.bzolnier@gmail.com> <200910291345.05888.bzolnier@gmail.com> <20091029.055901.24976117.davem@davemloft.net>
In-Reply-To: <20091029.055901.24976117.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200910291435.54203.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 October 2009 13:59:01 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Thu, 29 Oct 2009 13:45:05 +0100
> 
> > That *I* should be fixing the patch in question instead of the
> > submitter?
> 
> I'm saying that you should work with John to have him send a revert or
> whatever to me.

This is your responsibility to deal with your downstream maintainers,
not mine and since you have accepted John's patch I'm asking you to
revert rt2800pci patch from your tree.

-- 
Bartlomiej Zolnierkiewicz
