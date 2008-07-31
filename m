Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYGaJcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYGaJcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYGaJc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:32:29 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:54986 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbYGaJc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:32:28 -0400
Message-Id: <20080731092703.661994657@free-electrons.com>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jul 2008 11:27:03 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: michael@free-electrons.com
Subject: [patch 0/4] [resend] Add configuration options to disable features not needed on embedded devices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a resend of the small patch list I sent on July, 29th. I'm
resending the patches because they didn't make it to vger lists for
some setup problem on my side, and because I've been asked by Adrian
Bunk to resend them in order to get proper review.

However, please note that the patches removing ethtool and IGMP have
both been nack-ed by David Miller. The resend of these patches is not
an intent to workaround these NACKs in any way: I'm resending because
I've been asked to do so.

I apologize for the mess, and hope that this time, the mails will
reach vger lists.

Changes since previous post:

 * Add Matt Mackall's Signed-off-by on all patches
 * Make bonding and bridging select ethtool in the ethtool-related
   patch.

Sincerly,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
