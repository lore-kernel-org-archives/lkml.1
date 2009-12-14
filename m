Return-Path: <linux-kernel-owner+w=401wt.eu-S1751645AbZLNNFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbZLNNFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 08:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZLNNFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 08:05:39 -0500
Received: from tex.lwn.net ([70.33.254.29]:38716 "EHLO tex.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbZLNNFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 08:05:38 -0500
Date: Mon, 14 Dec 2009 06:05:35 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Masa <masa.korg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [How to upload our driver to "kernel.org"] Would you give me
 your  advice?
Message-ID: <20091214060535.24549129@bike.lwn.net>
In-Reply-To: <c7ac85d60912140256j4e1aa0edn9abba53ab1855ed5@mail.gmail.com>
References: <c7ac85d60912140256j4e1aa0edn9abba53ab1855ed5@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.19.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 19:56:23 +0900
Masa <masa.korg@gmail.com> wrote:

> Our company is planning to upload our device drivers to "kernel.org".
> And I am investigating "How to upload".

You'll find a lot of useful information in these parts of the kernel
Documentation directory:

	Documentation/HOWTO
	Documentation/development-process
	Documentation/SubmittingPatches

That would be the best place to start.

jon
