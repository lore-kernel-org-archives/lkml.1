Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZGMP4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZGMP4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZGMP4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:56:22 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:54382 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334AbZGMP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:56:21 -0400
Date: Mon, 13 Jul 2009 08:56:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lud <linux-usb@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 13 (usb/serial/option)
Message-Id: <20090713085626.182b73af.randy.dunlap@oracle.com>
In-Reply-To: <20090713180524.72f613dc.sfr@canb.auug.org.au>
References: <20090713180524.72f613dc.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A5B591A.01F5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 18:05:24 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20090710:


when CONFIG_PM=n:

drivers/usb/serial/option.c: In function 'option_suspend':
drivers/usb/serial/option.c:1254: error: 'struct usb_device' has no member named 'auto_pm'

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
