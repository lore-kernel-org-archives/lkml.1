Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZEYTc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZEYTc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZEYTcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:32:47 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44692 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZEYTcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:32:47 -0400
MIME-Version: 1.0
In-Reply-To: <20090525184816.GB6649@redhat.com>
References: <87y6slb7ug.fsf@devron.myhome.or.jp> <Pine.LNX.4.44L0.0905251127410.23874-100000@netrider.rowland.org> 
	<20090525184816.GB6649@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 25 May 2009 21:32:27 +0200
Message-ID: <ac3eb2510905251232t3f0c5029tb006f72c9ab6ef8e@mail.gmail.com>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 20:48, Michael S. Tsirkin <mst@redhat.com> wrote:

>> > > Dev sdb: unable to read RDB block 0

Is this Fedora? Or are you running a recent version of DeviceKit-disks?

We've seen such problems when trying to issue SAT commands to some USB
devices. If it's Fedora, this is fixed with an update to Fedora 11.

Kay
