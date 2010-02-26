Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935372Ab0BZHBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:01:42 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:46090 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935340Ab0BZHBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:01:41 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
Date: Fri, 26 Feb 2010 08:01:13 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <tj@kernel.org>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, david-b@pacbell.net,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <4B7CAF95.6020306@gmail.com> <51f3faa71002251515k51354eb6y3e2cfd1558dba2f1@mail.gmail.com> <20100225232528.GA24155@kroah.com>
In-Reply-To: <20100225232528.GA24155@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002260801.13405.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 26. Februar 2010 00:25:29 schrieb Greg KH:
> And yes, we can fix things after-the-fact with blacklists, but as Tejun
> so aptly described, it is a major pain to do so, and lots of users just
> get frustrated and never tell us that problems happen.

Exactly. We'd be better off with a whitelist in this case.

	Regards
		Oliver
