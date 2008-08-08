Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYHHJ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYHHJ4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYHHJ4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:56:12 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:22122 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753584AbYHHJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:56:11 -0400
Message-ID: <489C1833.40409@ru.mvista.com>
Date: Fri, 08 Aug 2008 13:56:03 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 6/2] ide-floppy: remove MODE_SENSE_* defines
References: <200808071911.22171.bzolnier@gmail.com>
In-Reply-To: <200808071911.22171.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Only MODE_SENSE_CURRENT (0x00) is ever used so just remove
> these defines and then drop no longer needed 'type' argument
> from idefloppy_create_mode_sense_cmd().
>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


