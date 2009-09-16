Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbZIPTYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbZIPTYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbZIPTYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:24:48 -0400
Received: from mx2.go2.pl ([193.17.41.42]:50595 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758643AbZIPTYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:24:47 -0400
X-Greylist: delayed 44057 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 15:24:47 EDT
From: Michal Witkowski <neuro@o2.pl>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: Explicitly putting a PCI device to ACPI D0
Date: Wed, 16 Sep 2009 21:24:36 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-ARCH; KDE/4.3.1; x86_64; ; )
References: <200909160910.24329.neuro@o2.pl> <20090916090907.2538fca1@jbarnes-g45> <a728f9f90909160933sba29b49oee2020024866b7d0@mail.gmail.com>
In-Reply-To: <a728f9f90909160933sba29b49oee2020024866b7d0@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909162124.36234.neuro@o2.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 of September 2009 18:33:58 you wrote:
> The xf86-video-ati ddx can turn off the displays and reduce the clocks
> and pcie lanes, but I haven't sorted out all the D3 stuff yet.  As for
> the switchable graphics, you might find the page below useful.  No
> idea if it will work or fry your hardware:
> http://ubuntuforums.org/showthread.php?p=7944950
> 
> Alex
> 

Thank you very very much :)
The above kernel module worked wonders for me.

Cheers,
Michal
