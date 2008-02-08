Return-Path: <linux-kernel-owner+w=401wt.eu-S1764613AbYBHRZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764613AbYBHRZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764345AbYBHRYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:24:45 -0500
Received: from homer.mvista.com ([63.81.120.155]:60903 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764340AbYBHRYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:24:43 -0500
Message-ID: <47AC908F.2060201@ru.mvista.com>
Date: Fri, 08 Feb 2008 20:25:35 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pdc202xx_old: always enable burst mode
References: <200802072214.44352.bzolnier@gmail.com>
In-Reply-To: <200802072214.44352.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Alan has noticed that distros always enabled burst mode
> (+ datasheet confirms that it is the right thing to do).

> Thus fix pdc202xx_old host driver to do it unconditionally
> and remove no longer needed CONFIG_PDC202XX_BURST option.

> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

WBR, Sergei
