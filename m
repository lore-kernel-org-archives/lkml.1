Return-Path: <linux-kernel-owner+w=401wt.eu-S965621AbXCGRa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965621AbXCGRa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965607AbXCGRa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:30:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:20820 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422903AbXCGRaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:30:22 -0500
Message-ID: <45EEF6A4.9090807@ru.mvista.com>
Date: Wed, 07 Mar 2007 20:30:12 +0300
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
References: <yyi8xe925vg.wl@toshiba.co.jp>	<yyi649d25qz.wl@toshiba.co.jp>	<45EECE5C.6030100@ru.mvista.com> <17902.60669.945986.186995@cargo.ozlabs.ibm.com>
In-Reply-To: <17902.60669.945986.186995@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul Mackerras wrote:

>>    I've already sent a patch fixing this one (along with many others) a month 
>>ago:

>>http://ozlabs.org/pipermail/linuxppc-dev/2007-February/031164.html

>>    I wonder iof it was ever considered... :-/

> The entire patch description was just this:

>>Convert the spinlocks in the PowerPC interrupt related code into the raw ones,
>>also convert the PURR and PMC related spinlocks...

> which says what you did, but gives NO CLUE about why this might be a
> good thing to do - what problem it fixes or what desirable outcome it
> produces.  I will not apply patches with inadequate descriptions.

    As I said, this was intended for the -rt patch, hence the question was for 
Ingo. I CC'ed the list just to keep people here in a loop.

> Paul.

WBR, Sergei
