Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZFCJAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZFCJAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZFCJAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:00:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53662 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752635AbZFCJAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:00:02 -0400
Date: Wed, 3 Jun 2009 09:58:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] tty: bfin_jtag_comm: emulate a TTY over the Blackfin
 EMUDAT/JTAG interface
Message-ID: <20090603095844.11217e35@lxorguk.ukuu.org.uk>
In-Reply-To: <1243970734-31541-1-git-send-email-vapier@gentoo.org>
References: <1243970734-31541-1-git-send-email-vapier@gentoo.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Jun 2009 15:25:34 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> The Blackfin JTAG interface has a 4 byte generic data field (EMUDAT).  With
> a little creative thinking, we can turn this into a TTY device.

Nifty - queued
