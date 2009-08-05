Return-Path: <linux-kernel-owner+w=401wt.eu-S933948AbZHEJch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbZHEJch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933817AbZHEJcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:32:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:56957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933796AbZHEJcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:32:36 -0400
Message-ID: <4A7951B0.10208@suse.de>
Date: Wed, 05 Aug 2009 18:32:32 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de> <20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Cox wrote:
> This looks like a random private devel hack sand

Why so?

> I don't see why it's appropriate for mainstream, especially as these
> "new things" don't exist mainstream either.

The new things is CUSE and it's already in mainstream.

Thanks.

-- 
tejun
