Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXCONmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXCONmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933563AbXCONmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:42:46 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:51998 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933549AbXCONmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:42:45 -0400
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
From: Ian Campbell <Ian.Campbell@XenSource.com>
To: vgoyal@in.ibm.com
Cc: Horms <horms@verge.net.au>, hbabu@us.ibm.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20070315132616.GH6766@in.ibm.com>
References: <1173891609.8591.41.camel@localhost.localdomain>
	 <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com>
	 <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com>
	 <1173961378.8591.63.camel@localhost.localdomain>
	 <20070315132616.GH6766@in.ibm.com>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 13:42:39 +0000
Message-Id: <1173966159.8591.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2007 13:42:44.0969 (UTC) FILETIME=[CFA83D90:01C76707]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 18:56 +0530, Vivek Goyal wrote:
> 
> Ideal place for this probably should have been arch dependent
> crash_dump.h file. But we don't have one and no point introducing one
> just for this  macro.

Agreed.

> This change looks good to me. 

Is there a kdump tree which you'll apply to or shall I resend CCing
apkm? (I'll add an Acked-by if that's ok).

Ian.


