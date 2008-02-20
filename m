Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbYBTJvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbYBTJvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbYBTJvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:51:15 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44214 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbYBTJvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:51:14 -0500
Message-ID: <47BBF811.7060007@s5r6.in-berlin.de>
Date: Wed, 20 Feb 2008 10:51:13 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Karl Dahlke <eklhad@comcast.net>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Valdis.Kletnieks@vt.edu
Subject: Re: adapter, what's in a name
References: <20080119181606.eklhad@comcast.net> <47BBF532.4030704@s5r6.in-berlin.de>
In-Reply-To: <47BBF532.4030704@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>   - There are other types of ABIs for I/O (character device files, block
> device files), message-based(?) I/O (netlink), configuration (configfs),
> and more.

PS:  Device files are not only suitable for bulk I/O via read and write,
they are also capable of event notification by means of poll and select
and of other kinds of I/O like configuration related I/O by means of ioctl.
-- 
Stefan Richter
-=====-==--- --=- =-=--
http://arcgraph.de/sr/
