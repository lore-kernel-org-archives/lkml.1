Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbZKGSmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbZKGSmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 13:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZKGSmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 13:42:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41884 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZKGSmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 13:42:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [00/99] 2.6.31.6 stable review
Date: Sat, 7 Nov 2009 19:43:21 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20091106221850.GA15408@kroah.com>
In-Reply-To: <20091106221850.GA15408@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911071943.21503.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 November 2009, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.31.6 release.
> There are 99 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> Responses should be made by November 8, 2009, 20:00:00 UTC.  Anything
> received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.6-rc1.gz
> and the diffstat can be found below.

Please also include commit 9905d1b411946fb3fb228e8c6529fd94afda8a92
(PM / yenta: Split resume into early and late parts (rev. 4)), which fixes a
regression present in the previous -stable kernel.

Thanks,
Rafael
