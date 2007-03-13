Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbXCMDGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbXCMDGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 23:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbXCMDGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 23:06:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:38665 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbXCMDGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 23:06:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wdt2x8TtnXTiYiqpqbSkktND9V8sv3taK4e4HFaWGXRO44Dg0CJRlOqrKWJ2Dt70S0IDAG4ekq1gwZkYZJ4d6PglwDty9y1Am112xBoIo/I8gOwRtWVhJxXk35fw7tKfJ07VtYa2c+YupYmi/E4TxgnzGTXkuPln+mF2xrnwMKs=
Message-ID: <df9815e70703122006g6906cf0cl582d7aa15ea31e29@mail.gmail.com>
Date: Tue, 13 Mar 2007 11:06:42 +0800
From: albcamus <albcamus@gmail.com>
To: "Teunis Peters" <teunis@wintersgift.com>
Subject: RE: Question: removal of syscall macros?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45804B99.2060008@wintersgift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45804B99.2060008@wintersgift.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2006/12/14, Teunis Peters <teunis@wintersgift.com>:

> Now that syscall macros have been pulled from the -mm tree, what method
> is recommended to use syscalls?
>
> (I've wasted a day grubbing through sources before giving up and copying
> the old syscall macros into one key driver)
>
> _syscall macros are used by:
> ATI driver  (no choice.  I'm working with laptops)

I have the same problem as yours.  Do  you have any idea to use ATI
firegl driver
in recent kernels ? Thanks in advance.

Regards,
albcamus
