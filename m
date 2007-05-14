Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbXENVDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbXENVDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbXENVDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:03:13 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:34632 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbXENVDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:03:13 -0400
Date: Mon, 14 May 2007 23:02:25 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Dave Jones <davej@redhat.com>
cc: Rob Landley <rob@landley.net>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tracking down disk spinups.
In-Reply-To: <20070514204651.GA7242@redhat.com>
Message-ID: <Pine.LNX.4.61.0705142302100.9570@yvahk01.tjqt.qr>
References: <20070514185734.GM27604@redhat.com> <200705141628.35617.rob@landley.net>
 <20070514204651.GA7242@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 16:46, Dave Jones wrote:
>
>*has sudden brainwave*
>
>Ahh, it's doing atime updates. Duh.

FYI+, noatime,nodiratime :)


	Jan
-- 
