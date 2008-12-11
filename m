Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYLKWFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYLKWFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbYLKWFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:05:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52272 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbYLKWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:05:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49418E99.9070202@s5r6.in-berlin.de>
Date: Thu, 11 Dec 2008 23:05:13 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: LINUX NEWBIE <lnxnewbie@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Add new capture device driver in Linux
References: <55fdf7050812021644o3bffc326n1eedfb699c2a141c@mail.gmail.com>	 <4936B4C7.909@s5r6.in-berlin.de> <55fdf7050812111316q57aca4a2idfe3caae4b1244ce@mail.gmail.com>
In-Reply-To: <55fdf7050812111316q57aca4a2idfe3caae4b1244ce@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LINUX NEWBIE wrote:
>     Thanks.  Where can I find an example of a basic PCIe analog
> capture driver?  Basically what does a basic PCIe capture driver need?

You can look at any PCI capture device driver, since there is no
difference between PCI and PCIe device drivers.
-- 
Stefan Richter
-=====-==--- ==-- -=-==
http://arcgraph.de/sr/
