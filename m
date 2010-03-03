Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0CCAGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:06:41 -0500
Received: from xenotime.net ([72.52.64.118]:34251 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751661Ab0CCAGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:06:40 -0500
Message-ID: <4B8DA809.1040205@xenotime.net>
Date: Tue, 02 Mar 2010 16:06:33 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: imunsie@au1.ibm.com
CC: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] Avoid implicit constant truncation
References: <1267574468-7609-1-git-send-email-imunsie@au.ibm.com>
In-Reply-To: <1267574468-7609-1-git-send-email-imunsie@au.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/10 16:01, imunsie@au1.ibm.com wrote:
> From: Ian Munsie <imunsie@au.ibm.com>
> 
> When building on 64 bit platforms, the compiler throws the following
> warning:
> 
> drivers/pci/probe.c:197: warning: large integer implicitly truncated to unsigned type
> 
> This patch adds an explicit truncation to silence the compiler warning.


Please see/read/use Documentation/SubmittingPatches.  E.g.:

The canonical patch subject line is:

    Subject: [PATCH 001/123] subsystem: summary phrase

I.e., the subject: should tell us that this is a PCI: patch.

(or even pci: -- i don't care which)

thanks,
-- 
~Randy
