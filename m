Return-Path: <linux-kernel-owner+w=401wt.eu-S932882AbXB1Ofx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbXB1Ofx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932883AbXB1Ofx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:35:53 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:65058 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882AbXB1Ofw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:35:52 -0500
Message-ID: <45E59344.40306@freescale.com>
Date: Wed, 28 Feb 2007 08:35:48 -0600
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net> <45E57CE5.5010003@zytor.com>
In-Reply-To: <45E57CE5.5010003@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:

> Also, if QE really is just CPM v3, and they share the same minors, why 
> change the name?

Because the QE isn't called CPM v3, that's just one way to think about 
it.  It's a different device that has some backwards compatibility, but 
the drivers are all distinct and they all use "QE" and not "CPM" in 
their names.

