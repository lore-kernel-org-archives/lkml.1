Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXKDSto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXKDSto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXKDStg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:49:36 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:41769 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbXKDStg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:49:36 -0500
Date: Sun, 4 Nov 2007 13:48:17 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Marco Costalba <mcostalba@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: List of possible duplicated include files in include/
In-Reply-To: <e5bfff550711041044p7c07c42g836461e81a6005a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711041347001.12818@localhost.localdomain>
References: <e5bfff550711041044p7c07c42g836461e81a6005a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007, Marco Costalba wrote:

> Here the number of false positives is overhelming, but perhaps there
> are also _real_ duplicated include somewhere in the bunch:
>
> include/acpi/acpi_bus.h:
> #include <linux/device.h>

... snip header file output ...

i deliberately left out header files from my script output.  i can
tweak the script and add this to the web page as well.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
