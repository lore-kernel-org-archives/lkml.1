Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbXLULon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbXLULon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXLULof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:44:35 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:30115 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585AbXLULoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:44:34 -0500
Message-ID: <476BA737.3060305@ru.mvista.com>
Date: Fri, 21 Dec 2007 14:44:55 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/63] ide-cd: fix ACER/AOpen 24X CDROM speed reporting
 on big-endian machines
References: <200712200151.39973.bzolnier@gmail.com>
In-Reply-To: <200712200151.39973.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Fix ACER/AOpen 24X CDROM speed reporting on big-endian machines
>   by adding missing le16_to_cpu() calls.

> While at it:
> * Replace ntohs() by be16_to_cpu().

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
