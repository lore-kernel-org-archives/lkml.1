Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbXLUMph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbXLUMph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbXLUMp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:45:29 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:30796 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750723AbXLUMp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:45:28 -0500
Message-ID: <476BB57D.3050306@ru.mvista.com>
Date: Fri, 21 Dec 2007 15:45:49 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/63] ide-cd: remove unused and write-only struct ide_cd_config_flags
 fields
References: <200712200208.43246.bzolnier@gmail.com>
In-Reply-To: <200712200208.43246.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> unused fields:
> * ->writing
> * ->reserved

> write-only fields:
> * ->playmsf_as_bcd
> * ->subchan_as_bcd
> * ->test_write
> * ->supp_disc_present

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

