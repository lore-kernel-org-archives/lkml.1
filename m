Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbYBFUnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbYBFUnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYBFUn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:43:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:45309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbYBFUn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:43:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bc9M/Ciu7xdTbxIjm/CZE5zgDaYCEiKp5lnwtJIovHn/gI2fHD9jQmQ1Yjw0ydPQaKCER1Ma8WMymSgFlT67tHXsUvpZQ86Tbpp62/TR9HvWnX5YOgy+oDco1oJPN3B5Q2Vl8K4Mlkgm2W22C+3GDTfOJhmtrtyGdzExtKV6IDA=
Message-ID: <9e4733910802061243h2757d41fwe0813adacc86a0ee@mail.gmail.com>
Date: Wed, 6 Feb 2008 15:43:26 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080125180232.GA4613@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080125180232.GA4613@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There a company that is providing a common API for writting Windows
and Linux drivers. Last time I was using a Macraigor JTAG it was based
on this proprietary dual platform driver.

http://www.macraigor.com/cgi_bin/counters/unicounter.pl?name=counters/ocd_cmdr_linux&deliver=http://www.macraigor.biz/gnu/mcgr-hwsupport-4.8-0.i386.rpm

The dual platform driver was from Jungo.
http://www.jungo.com/

WinDriver™ USB for Linux automates and simplifies the development of
user-mode Linux device drivers and hardware control applications for
USB peripheral devices. No Linux kernel knowledge or kernel level
programming required.

-- 
Jon Smirl
jonsmirl@gmail.com
