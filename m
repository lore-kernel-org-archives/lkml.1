Return-Path: <linux-kernel-owner+w=401wt.eu-S2992618AbXCGVVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992618AbXCGVVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992621AbXCGVVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:21:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:22786 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992619AbXCGVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:21:39 -0500
Message-ID: <45EF2CD8.3050804@ru.mvista.com>
Date: Thu, 08 Mar 2007 00:21:28 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
Cc: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/6 -rt] powerpc 2.6.20-rt8: to convert spinlocks to raw
 ones.
References: <yyi8xe925vg.wl@toshiba.co.jp>	<yyi649d25qz.wl@toshiba.co.jp>	<45EECE5C.6030100@ru.mvista.com>	<17902.60669.945986.186995@cargo.ozlabs.ibm.com>	<45EEF6A4.9090807@ru.mvista.com> <17903.4302.502364.126701@cargo.ozlabs.ibm.com>
In-Reply-To: <17903.4302.502364.126701@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul Mackerras wrote:

>>    As I said, this was intended for the -rt patch, hence the question was for 
>>Ingo. I CC'ed the list just to keep people here in a loop.

> OK, fair enough, but I still think the patch description was
> inadequate.  In the -rt context, I would at least expect to see some
> explanation as to why those particular locks needed to be converted.

    I've floowed up to my patch with such explanation. In the context of an-rt 
patch itself, it was just too clear, hence I didn't go into explanations in 
the patch itself. :-)

> Paul.

WBR, Sergei
