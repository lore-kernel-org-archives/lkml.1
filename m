Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214Ab0ALQXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0ALQXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137Ab0ALQXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:23:08 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:43027 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab0ALQXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:23:06 -0500
Date: Tue, 12 Jan 2010 08:22:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for January 12 (input)
Message-Id: <20100112082221.8c3a4f95.randy.dunlap@oracle.com>
In-Reply-To: <20100112171739.2011a0eb.sfr@canb.auug.org.au>
References: <20100112171739.2011a0eb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B4CA1DD.01F4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 17:17:39 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100109:


drivers/input/input.c:841: warning: right shift count >= width of type

and when CONFIG_PROC_FS is disabled:

drivers/input/input.c:1171: error: implicit declaration of function 'input_bits_to_string'


---
~Randy
