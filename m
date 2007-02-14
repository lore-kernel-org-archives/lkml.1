Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbXBNJ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbXBNJ6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbXBNJ6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:58:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:56525 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbXBNJ57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:57:59 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Subject: Re: Bug in current -git tree causing dbus and gnome to chew up cpu time
Date: Wed, 14 Feb 2007 01:57:58 -0800
User-Agent: KMail/1.9.5
Cc: "Greg KH" <greg@kroah.com>, torvalds@linux-foundation.org, neilb@suse.de,
       viro@zeniv.linux.org.uk, hch@lst.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070213195116.GA5181@kroah.com> <5a4c581d0702140147s7931bd63ief299780fa6963a5@mail.gmail.com>
In-Reply-To: <5a4c581d0702140147s7931bd63ief299780fa6963a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702140157.59252.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've described the problem and possible fixes in the "Re: [PATCH] Fix d_path 
for lazy unmounts" thread, Message-Id: 200702140019.36378.agruen@suse.de.

Thanks,
Andreas
