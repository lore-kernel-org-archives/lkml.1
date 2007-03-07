Return-Path: <linux-kernel-owner+w=401wt.eu-S2992505AbXCGTmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992505AbXCGTmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992514AbXCGTmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:42:06 -0500
Received: from ozlabs.org ([203.10.76.45]:49946 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992513AbXCGTmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:42:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17903.4302.502364.126701@cargo.ozlabs.ibm.com>
Date: Thu, 8 Mar 2007 06:21:50 +1100
From: Paul Mackerras <paulus@samba.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/6 -rt] powerpc 2.6.20-rt8: to convert spinlocks to raw
 ones.
In-Reply-To: <45EEF6A4.9090807@ru.mvista.com>
References: <yyi8xe925vg.wl@toshiba.co.jp>
	<yyi649d25qz.wl@toshiba.co.jp>
	<45EECE5C.6030100@ru.mvista.com>
	<17902.60669.945986.186995@cargo.ozlabs.ibm.com>
	<45EEF6A4.9090807@ru.mvista.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov writes:

>     As I said, this was intended for the -rt patch, hence the question was for 
> Ingo. I CC'ed the list just to keep people here in a loop.

OK, fair enough, but I still think the patch description was
inadequate.  In the -rt context, I would at least expect to see some
explanation as to why those particular locks needed to be converted.

Paul.
