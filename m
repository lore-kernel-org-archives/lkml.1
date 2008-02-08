Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbYBHRcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbYBHRcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbYBHRcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:32:00 -0500
Received: from homer.mvista.com ([63.81.120.155]:60968 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757147AbYBHRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:31:59 -0500
Message-ID: <47AC9242.6040705@ru.mvista.com>
Date: Fri, 08 Feb 2008 20:32:50 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Anton Salnikov <asalnikov@ru.mvista.com>
Subject: Re: [PATCH 2.5/3] palm_bk3710: port initialization/probing bugfix
References: <200802072150.34389.bzolnier@gmail.com>
In-Reply-To: <200802072150.34389.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Probe port _after_ it is fully initialized.

    Hm, I thought the usual sequence is vice versa: you first probe and then 
initialize. :-)

> Cc: Anton Salnikov <asalnikov@ru.mvista.com>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
