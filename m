Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbZKRSvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbZKRSvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZKRSvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:51:35 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:63985 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932367AbZKRSvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:51:32 -0500
Message-ID: <4B04425D.5080604@ru.mvista.com>
Date: Wed, 18 Nov 2009 21:52:13 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpt366: remove dead old timing tables
References: <200911181932.07651.bzolnier@gmail.com>
In-Reply-To: <200911181932.07651.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> It has been enough time since introduction of the new timing tables
> (commit 809b53c from Dec 12 2007) and the old timing tables are still
> available in pata_hpt37x.c (or git history) if somebody needs them.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

WBR, Sergei
