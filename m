Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbXJMHF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbXJMHF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXJMHFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:05:49 -0400
Received: from smtp01.mtu.ru ([62.5.255.48]:56448 "EHLO smtp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbXJMHFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:05:48 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [git patches] libata update
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Date: Sat, 13 Oct 2007 11:05:43 +0400
References: <20071012194002.GA1545@havoc.gtf.org>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20071013070535.D339CA364AB@smtp01.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

> * Asynchronous notification -- finally userspace CD-ROM polling can go
> away!
>   (NOTE: waiting on James B to apply the piece that actually makes this
>   work...)

Does it depend on hardware offering suitable support? What are chances for
it to work on 5 years old DVD-ROM?

