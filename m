Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZEDMmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZEDMmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 08:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZEDMmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 08:42:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36422 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754472AbZEDMmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 08:42:05 -0400
Date: Mon, 4 May 2009 13:39:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 4/7] blkio-cgroup: The body of blkio-cgroup
Message-ID: <20090504133942.35dbe7cc@lxorguk.ukuu.org.uk>
In-Reply-To: <20090504120544.GA3986@linux>
References: <20090428.214423.193684619.ryov@valinux.co.jp>
	<20090428.214457.226801820.ryov@valinux.co.jp>
	<20090428.214535.71090234.ryov@valinux.co.jp>
	<20090428.214604.104034341.ryov@valinux.co.jp>
	<20090504120544.GA3986@linux>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> few minor coding style issues reported by checkpatch.pl:

checkpatch is a *guide* not some dictator of style. If it's more readable
the way it is, or it's following existing style (eg with the export
symbols in a group at the bottom) then checkpatch is best ignored.
