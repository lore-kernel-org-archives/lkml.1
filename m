Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbYEYT1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbYEYT1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbYEYT11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:27:27 -0400
Received: from 57.Red-88-2-100.staticIP.rima-tde.net ([88.2.100.57]:49858 "EHLO
	mail.leals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759187AbYEYT10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:27:26 -0400
From: Davi Leal <davi@leals.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: I was a volunteer
Date: Sun, 25 May 2008 21:27:19 +0200
User-Agent: KMail/1.9.7
Cc: "Tom Spink" <tspink@gmail.com>, linux-kernel@vger.kernel.org
References: <200805251812.41552.davi@leals.com> <e2e108260805250920m3610edf7y613b4abc24d4f0ee@mail.gmail.com> <200805251844.40005.davi@leals.com>
In-Reply-To: <200805251844.40005.davi@leals.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252127.21022.davi@leals.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   * Code that depends on LINUX_VERSION_CODE & KERNEL_VERSION < 2.6 can be
>     * deleted in most cases. (Mostly/all? done)

The above task seems already done in git/torvalds/linux-2.6.git . Maybe you 
could remove it from http://kernelnewbies.org/KernelJanitors/Todo/ApiChanges


The below one seems to be done too:

  * Replace (un)register_ioctl32_conversion with ioctl_compat



P.S.: I am going to postpound my contribution due to others tasks are complex 
for me now.
