Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYBISGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYBISGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYBISGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:06:42 -0500
Received: from h155.mvista.com ([63.81.120.155]:5353 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751563AbYBISGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:06:41 -0500
Message-ID: <47ADEBE4.1010607@ru.mvista.com>
Date: Sat, 09 Feb 2008 21:07:32 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] ide: factor out code unregistering devices from
 ide_unregister()
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <20080208004502.17746.73284.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004502.17746.73284.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Factor out code unregistering devices from ide_unregister() to
> ide_port_unregister_devices().

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
