Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYDALGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYDALGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbYDALGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:06:39 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:1117 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYDALGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:06:39 -0400
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, =?utf-8?b?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Apr 2008 13:06:32 +0200
In-Reply-To: <47F1F644.4060000@yandex.ru>
Message-ID: <878wzx25s7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Apr 2008 10:59:55.0215 (UTC) FILETIME=[84A455F0:01C893E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind@yandex.ru> writes:

> Tomasz Chmielewski wrote:
> > For me, the motivators to wait for LogFS are mainly the facts that it
> > can work on traditional block devices, and not only on pure flash:
> 
> Sorry Thomasz, for me this makes zero sense. There are _much_ better file
> systems for block devices.

I think he refers to flash disks appearing as block devices, like
usb sticks or similar.

-Andi
