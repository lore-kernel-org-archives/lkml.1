Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXFLQmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXFLQmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXFLQmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:42:05 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:37480 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbXFLQmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:42:05 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: cannot set IP for ethernet
Date: Tue, 12 Jun 2007 18:41:37 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200706121441.13561.oliver@neukum.org> <200706121613.47718.oliver@neukum.org> <Pine.LNX.4.64.0706121714290.19578@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706121714290.19578@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706121841.37350.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 12. Juni 2007 schrieb Jan Engelhardt:
> 
> On Jun 12 2007 16:13, Oliver Neukum wrote:
> >> On Jun 12 2007 14:41, Oliver Neukum wrote:
> >> >
> >> >with 2.6.22-rc4-git2 I am getting errors when setting IP for ethernet
> >> >interfaces:
> >> >
> >> >ioctl(4, SIOCSIFADDR, 0x7fff94931600)   = -1 ENOBUFS (No buffer space available)
> 
> Do you run VPN or some sort?

Yes, racoon, but the connection was down when I tried setting the IP.

	Regards
		Oliver
