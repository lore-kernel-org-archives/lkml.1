Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZEUS5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZEUS5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 14:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZEUS50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 14:57:26 -0400
Received: from h155.mvista.com ([63.81.120.155]:58100 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753388AbZEUS50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 14:57:26 -0400
Message-ID: <4A15A44B.2020407@ru.mvista.com>
Date: Thu, 21 May 2009 22:58:19 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] hpt366: enable all quirks for devices on quirk_drives[]
 list
References: <200905201733.58869.bzolnier@gmail.com>
In-Reply-To: <200905201733.58869.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Enable also quirks in do_reset1() and ide_config_drive_speed()
> for devices on quirk_drives[] list.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
