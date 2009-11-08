Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbZKHSOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbZKHSOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 13:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZKHSOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 13:14:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:58456 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZKHSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 13:14:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=bExPlMFw6An4X97SneP/KY0bNziOeI7Gk19MLtcos96UjumrdZEvDlqNzB16wmVX42
         1MrX4Vr75Gefs9OSEIMwpdZ3udXpImnO5zTQ+WsR51ObidnP0BVDUNtaoHyA3YAZ7ykc
         Yau4kPQ0GZc1Aw9NAYWh38bNMD78lkSPpNWWk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [git patches] rt2800 drivers updates
Date: Sun, 8 Nov 2009 19:13:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200911081433.32005.bzolnier@gmail.com> <4AF6DE9A.1030204@gmail.com> <200911081622.52151.bzolnier@gmail.com>
In-Reply-To: <200911081622.52151.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200911081913.04994.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 November 2009 16:22:52 Bartlomiej Zolnierkiewicz wrote:
> On Sunday 08 November 2009 16:07:06 Gertjan van Wingerde wrote:
> 
> > Ehm, nothing seems to be available in the git repository you pointed to. Did you push it there?
> 
> Yes but kernel.org mirroring seems to be snail-slow today..

The current branch is now rt2800-v3.1, changes:
- fixed build problem reported by Hauke Mehrtens
- added "rt2x00: Remove deprecated ieee80211_rx_status->qual usage" patch
  from Ivo and "rt2x00: Update copyright statements." from you

It may take some time to get it to kernel.org mirrors though..

-- 
Bartlomiej Zolnierkiewicz
