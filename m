Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbXDDXfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbXDDXfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXDDXfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:35:50 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:37320 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXDDXfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:35:48 -0400
Date: Wed, 04 Apr 2007 17:34:56 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: set up new kernel with grub
In-reply-to: <fa.BNamKVxrrt25RRODKJNDbnxNoSs@ifi.uio.no>
To: Michael <gonwg@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46143620.9000304@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.BNamKVxrrt25RRODKJNDbnxNoSs@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael wrote:
> Hi,
> 
> I compiled a new kernel: 2.6.20.3, and hope to test it without removing 
> my old kernel.
> 
> Here is what I did by following 
> http://searchenterpriselinux.techtarget.com/tip/0,289483,sid39_gci1204148,00.html 

Those instructions are way out of date. All you should need to do is 
"make modules_install install".

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

