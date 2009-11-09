Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZKIRzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZKIRzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZKIRzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:55:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43868 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752529AbZKIRzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:55:36 -0500
Date: Mon, 9 Nov 2009 17:57:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mariusz Smykula <mariuszs@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.29+ broke Cisco VPN Client
Message-ID: <20091109175728.4eec67b9@lxorguk.ukuu.org.uk>
In-Reply-To: <3642a3130911090908i55d6e1f2y6d9a5106d9febfc6@mail.gmail.com>
References: <3642a3130911090908i55d6e1f2y6d9a5106d9febfc6@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009 18:08:40 +0100
Mariusz Smykula <mariuszs@gmail.com> wrote:

> Kernel 2.6.31 go mainstream and there new problem grow up for many
> users of poor Cisco VPN Client with certs authentication (there is no
> alternative for this). 

I must have imagined openconnect. Failing that you need to talk to your
distro if they shipped the module or to cisco.

Alan
