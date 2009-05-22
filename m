Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZEVKTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZEVKTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZEVKTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:19:43 -0400
Received: from h155.mvista.com ([63.81.120.155]:26242 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751791AbZEVKTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:19:42 -0400
Message-ID: <4A167C3A.7010203@ru.mvista.com>
Date: Fri, 22 May 2009 14:19:38 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ide: add IDE_DFLAG_NIEN_QUIRK device flag
References: <200905201735.15489.bzolnier@gmail.com>
In-Reply-To: <200905201735.15489.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Add IDE_DFLAG_NIEN_QUIRK device flag and use it instead of
> drive->quirk_list.
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


