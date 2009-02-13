Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbZBMNf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbZBMNf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZBMNfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:35:17 -0500
Received: from ns.suse.de ([195.135.220.2]:37573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbZBMNfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:35:15 -0500
Message-ID: <499575D2.3000708@suse.de>
Date: Fri, 13 Feb 2009 14:29:54 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, gregkh@suse.de,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next 2/2] pohmelfs: fix printk format warnings
References: <20090213125944.GB7003@orion> <20090213131400.GF23879@ioremap.net>
In-Reply-To: <20090213131400.GF23879@ioremap.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Doesn't size_t have %zu format?

That's right. So that would be even more accurate.

Thanks,
Frank

