Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYANTha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYANTha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbYANThX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:37:23 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35675 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYANThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:37:22 -0500
Date: Mon, 14 Jan 2008 14:37:19 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Possibly silly Q?
In-Reply-To: <200801141434.00934.gene.heskett@gmail.com>
Message-ID: <alpine.LFD.1.00.0801141436590.22800@localhost.localdomain>
References: <200801141434.00934.gene.heskett@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008, Gene Heskett wrote:

> Greetings;
>
> Do we have a utility that can force the kernel to re-read, and
> re-initialize itself to a given drives partition tables without
> having to reboot if one is working with a drive that is not part of
> the required kernel directory tree?

i would try "partprobe".

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
========================================================================
