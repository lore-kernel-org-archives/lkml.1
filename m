Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0BVX70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:59:26 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:58904 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0BVX7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:59:24 -0500
From: Oliver Neukum <oliver@neukum.org>
To: GeunSik Lim <leemgs1@gmail.com>
Subject: Re: question on readahead and sync mounting
Date: Tue, 23 Feb 2010 00:59:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
References: <201002230032.18705.oliver@neukum.org> <49b7c2351002221548ma5b8e81m80ac4b60a6eb9d9d@mail.gmail.com>
In-Reply-To: <49b7c2351002221548ma5b8e81m80ac4b60a6eb9d9d@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002230059.09390.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 23. Februar 2010 00:48:39 schrieben Sie:
> Please, Refer to below articles to understand readahead essentially.
> 
> http://lwn.net/Articles/235164/ (On-demand readahead by corbet)
> http://kernelnewbies.org/Linux_2_6_23#head-102af265937262a7a21766ae58fddc1a29a5d8d7(
> On-demand read-ahead on Linux 2.6.23)

OK, I am looking for a way to make sure read requests on a SCSI drive
actually hit the bus after a certain event. Is there a way to do this without
tossing away the whole cache?

	Regards
		Oliver
