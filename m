Return-Path: <linux-kernel-owner+w=401wt.eu-S1765492AbXHNQr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765492AbXHNQr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763403AbXHNQrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:47:21 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:20466 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbXHNQrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SFs5XL12meKHAJxbgPt54wYNuRKIJYMX28mPq8Sy5g0UA01dvqwbm/JTcdxkXxs7hM63KHF1AVBkdh9aq0ewuke4HYZvNgVptdo4UbZ+mbHEnXFd+cRCIdFpVmKzp4JuzNzMKYwsea6rNOMA6WT1smPL6rbKK0C7ZrE7xDHb3gI=
Message-ID: <be1b757c0708140947k153eecfub713371a5b29805a@mail.gmail.com>
Date: Tue, 14 Aug 2007 18:47:18 +0200
From: "Karl Meyer" <adhocrocker@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070814070901.GA14693@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com>
	 <20070813165821.GA19356@electric-eye.fr.zoreil.com>
	 <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com>
	 <20070814070901.GA14693@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I was wrong, still testing....

2007/8/14, Francois Romieu <romieu@fr.zoreil.com>:
> Karl Meyer <adhocrocker@gmail.com> :
> [...]
> > dmesg, interrupts and .config are attached. I will have a look at git bisect.
>
> Can you reproduce the problem when nvidia binary-only stuff is not loaded
> after boot ?
>
> --
> Ueimor
>
