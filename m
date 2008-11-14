Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYKNSLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYKNSLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYKNSLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:11:23 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:35176 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYKNSLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:11:23 -0500
Date: Fri, 14 Nov 2008 10:11:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 14 (staging#2)
Message-Id: <20081114101111.f138c2ba.randy.dunlap@oracle.com>
In-Reply-To: <20081114184021.ed198f4b.sfr@canb.auug.org.au>
References: <20081114184021.ed198f4b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.491DBF43.0075:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 18:40:21 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20081113:
> 
> New tree:
> 	staging

ERROR: "usb_deregister" [drivers/staging/asus_oled/asus_oled.ko] undefined!
ERROR: "usb_get_dev" [drivers/staging/asus_oled/asus_oled.ko] undefined!
ERROR: "usb_bulk_msg" [drivers/staging/asus_oled/asus_oled.ko] undefined!
ERROR: "usb_put_dev" [drivers/staging/asus_oled/asus_oled.ko] undefined!
ERROR: "usb_register_driver" [drivers/staging/asus_oled/asus_oled.ko] undefined!

(CONFIG_USB=n)

---
~Randy
