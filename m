Return-Path: <linux-kernel-owner+w=401wt.eu-S1161142AbXCNLX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161142AbXCNLX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161146AbXCNLX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:23:57 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:2832 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161142AbXCNLX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:23:56 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [ANNOUNCE] iproute2 2.6.20-070313
Date: Wed, 14 Mar 2007 12:23:48 +0100
User-Agent: KMail/1.9.6
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       lartc@mailman.ds9a.nl
References: <20070313151549.332004c9@freekitty>
In-Reply-To: <20070313151549.332004c9@freekitty>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703141223.48927.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 of March 2007, Stephen Hemminger wrote:
> This is an experimental to the iproute2 command set.
>
> The version number includes the kernel version to denote what features are
> supported. The same source should build on older systems, but obviously the
> newer kernel features won't be available. As much as possible, this package
> tries to be source compatible across releases.
>
> It can be downloaded from:
>  
> http://developer.osdl.org/dev/iproute2/download/iproute2-2.6.20-070313.tar.
>gz

This patch

http://www.mail-archive.com/netdev@vger.kernel.org/msg27506.html

didn't make into upstream linux kernel it seems.

The question is - are patches adding some functionality that's not in upstream 
kernel accepted?

There is one wrr patch for iproute floating around that I'm thinking about.

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
