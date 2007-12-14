Return-Path: <linux-kernel-owner+w=401wt.eu-S1763005AbXLNIqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005AbXLNIqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXLNIqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:46:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:50989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbXLNIql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:46:41 -0500
From: Dirk Heinrichs <dirk.heinrichs@online.de>
Organization: Privat
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with matrox framebuffer in 2.6.23.x
Date: Fri, 14 Dec 2007 09:46:32 +0100
User-Agent: KMail/1.9.50
References: <200712131328.33606.dirk.heinrichs@online.de>
In-Reply-To: <200712131328.33606.dirk.heinrichs@online.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712140946.33395.dirk.heinrichs@online.de>
X-Provags-ID: V01U2FsdGVkX19/yMXPe+UASpmhCl4+4ZcbucrtHDjuiRF054T
 W1UqFwANV3QF8yAViWNylke0NOM+QnRmlqeyRQ9rccshi777cj
 UeKeHBFBfC82PXsYfO1Qg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 December 2007 13:28:25 Dirk Heinrichs wrote:

> ... and the fb boot options for all kernels are: video=matroxfb:vesa:0x105.

Got a hint via p.m. to change the above to video=matroxfb:1024x768-16@85 for 
the 2.6.23.x kernels. And it works fine.

Bye...

	Dirk
