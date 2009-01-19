Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZASOUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZASOUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbZASOSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:18:48 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:53003 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758825AbZASOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:18:46 -0500
Message-ID: <49748BE4.4000505@ru.mvista.com>
Date: Mon, 19 Jan 2009 17:19:16 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ide: more core code housekeeping
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> SFF I/O code goes to ide-io-sff.c and error handling to ide-eh.c...

    There's no such thing as SFF I/O code I'm afraid -- whatever libata 
authors might think...

MBR, Sergei
