Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZEYUu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZEYUu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZEYUus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:50:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:22762 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZEYUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=gta2WROrFQAos/JnFmuKjhOc3Ya7BBaTL3QugCJiglkmulp/YDXjxBSjED8GhS+Aj0
         +q5wd5XNsGdMVd59wwBWPeQxQR1Ie95gWfBYNvvY4ioMzBeSG2zTSz2EzSQJ4aGhzTCE
         SawLdv+638R7oGQMkv6a5rRSq+aWnlFuFU+ps=
Date: Mon, 25 May 2009 15:50:43 -0500
From: Jay Cliburn <jcliburn@gmail.com>
To: Eric Cooper <ecc@cmu.edu>
Cc: linux-kernel@vger.kernel.org, Vlad Cerny <vlad.cerny@gmail.com>,
       netdev@vger.kernel.org, jie.yang@atheros.com
Subject: Re: Network data corruption on atl1e
Message-ID: <20090525155043.5b8b1a90@osprey.hogchain.net>
In-Reply-To: <20090524182042.GA8159@localhost>
References: <88a913b70905211029j38e22083g407dfba5c17754a1@mail.gmail.com>
	<20090524182042.GA8159@localhost>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 May 2009 14:20:42 -0400
Eric Cooper <ecc@cmu.edu> wrote:

> Reading large files over NFS using the at1le Ethernet driver results
> in data corruption in 2.6.29.
> 
> Further details are in this thread:
>   http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-May/002199.html 
> 
> I'll be happy to help with further tests, etc.  Please CC Vlad and me
> on any followups, thanks.
> 

Adding netdev and maintainers to cc.

Jay
