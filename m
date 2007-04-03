Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXDCLvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXDCLvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 07:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965565AbXDCLvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 07:51:09 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:43017 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965564AbXDCLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 07:51:08 -0400
Message-ID: <46123F98.2010706@s5r6.in-berlin.de>
Date: Tue, 03 Apr 2007 13:50:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Carlo Florendo <subscribermail@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel source dependency
References: <46120EBE.8080705@gmail.com>
In-Reply-To: <46120EBE.8080705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Florendo wrote:
> The kernel configure target "make menuconfig" requires ncurses.   FWIW, it
> could probably be better if the error message would indicate that that
> ncurses is necessary for "make menuconfig" to run and that the user could
> be prompted to install the package.

You could select your distributor's kernel source package in the package
manager of your choice and see which packages are auto-selected or
reported as required.
-- 
Stefan Richter
-=====-=-=== -=-- ---==
http://arcgraph.de/sr/
