Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbYAVOQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbYAVOQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYAVOQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:16:01 -0500
Received: from h155.mvista.com ([63.81.120.155]:58502 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752932AbYAVOQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:16:00 -0500
Message-ID: <4795FAD3.4050306@ru.mvista.com>
Date: Tue, 22 Jan 2008 17:16:51 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] ide: use __ide_set_handler() in ide_execute_command()
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain> <20080121233144.30311.5346.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233144.30311.5346.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Use __ide_set_handler() in ide_execute_command().

> While at it:

> * Fix whitespace damage in ide_execute_command().

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
