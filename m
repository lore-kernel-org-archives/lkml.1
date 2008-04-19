Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbYDSQtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbYDSQtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYDSQs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:48:59 -0400
Received: from h155.mvista.com ([63.81.120.155]:22857 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752129AbYDSQs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:48:58 -0400
Message-ID: <480A2250.20201@ru.mvista.com>
Date: Sat, 19 Apr 2008 20:48:16 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] siimage: do clocking register posting earlier in
 setup_mmio_siimage()
References: <200804092051.01552.bzolnier@gmail.com>
In-Reply-To: <200804092051.01552.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Do clocking register posting earlier in setup_mmio_siimage()
> to match code in init_chipset_siimage().

> This is a preparation for the next patch which merges PCI and MMIO
> code paths together.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
