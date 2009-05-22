Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZEVIfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZEVIfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZEVIfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:35:46 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47713 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZEVIfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:35:45 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: How to tell whether a struct file is held by a process?
Date: Fri, 22 May 2009 10:36:04 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <20090521095217.GU8633@ZenIV.linux.org.uk> <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com> <20090521231452.676d4898@lxorguk.ukuu.org.uk>
In-Reply-To: <20090521231452.676d4898@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221036.06097.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 22. Mai 2009 00:14:52 schrieb Alan Cox:
> My feeling too - there simply isn't any need for kernel infrastructure
> here. The only case the kernel must be involved is when you need

That seems a reasonable solution to me.

	Regards
		Oliver

