Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZK2XBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZK2XBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 18:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZK2XBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 18:01:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44087 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750956AbZK2XBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 18:01:08 -0500
Date: Sun, 29 Nov 2009 23:03:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "werner" <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pci=off
Message-ID: <20091129230310.265110e2@lxorguk.ukuu.org.uk>
In-Reply-To: <web-96228708@zbackend1.aha.ru>
References: <web-96228708@zbackend1.aha.ru>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The most frequent problem is that IDE drives are not 
> found, or cannot be accessed because reclaimed as ocupied. 

Some detailed diagnostic information would be useful.

> screen become black and nothing more happened.  The same 
> happens on that laptop with all newer Slackware kernels

First reporting point for distro kernels is the distribution. Do modern
non-Slackware kernels (eg Fedora, SuSE) work on the problem laptop ?
