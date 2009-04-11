Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbZDKRpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbZDKRpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 13:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbZDKRoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 13:44:54 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:49318 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbZDKRox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 13:44:53 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Apr 2009 13:44:53 EDT
From: Konrad Rzeszutek <ketuzsezr@darnok.org>
Reply-To: ketuzsezr@darnok.org
To: Ashutosh Naik <ashutosh.naik@gmail.com>
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC attribute  structure in sysfs
Date: Sat, 11 Apr 2009 13:34:32 -0400
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pjones@redhat.com,
       "Vishnu V. Mandyam" <vishnu@chelsio.com>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
In-Reply-To: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904111334.33642.ketuzsezr@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 April 2009 09:29:36 Ashutosh Naik wrote:
> This patch fixes the display of a few fields in the iBFT NIC attribute
> structure in sysfs.
>
> Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>
> Signed-off-by: Vishnu V<vishnu@chelsio.com>

Thanks for finding such glaring copy-n-paste error.

Acked-off-by:Konrad Rzeszutek <ketuzsezr@darnok.org>


