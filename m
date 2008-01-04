Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYADScR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYADScR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 13:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYADScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 13:32:04 -0500
Received: from h155.mvista.com ([63.81.120.155]:1893 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752450AbYADScD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 13:32:03 -0500
Message-ID: <477E7BCA.7060206@ru.mvista.com>
Date: Fri, 04 Jan 2008 21:32:42 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ide-pmac: macio resource freeing bugfix
References: <200712301824.51003.bzolnier@gmail.com>
In-Reply-To: <200712301824.51003.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Release DMA resource before zeroing pmif.

> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
