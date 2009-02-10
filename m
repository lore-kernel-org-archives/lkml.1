Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZBJSSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZBJSSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZBJSSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:18:09 -0500
Received: from h155.mvista.com ([63.81.120.155]:47083 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753851AbZBJSSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:18:09 -0500
Message-ID: <4991C4F3.2040404@ru.mvista.com>
Date: Tue, 10 Feb 2009 21:18:27 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ide: add ->dma_expiry method and remove ->dma_exec_cmd
 one
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain> <20090209232012.32406.88338.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209232012.32406.88338.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Rename dma_timer_expiry() to ide_dma_sff_expiry() and export it.

> * Add ->dma_expiry method

    This name doesn't seem to make much sense. Why not leave it dma_timer_expiry?

MBR, Sergei
