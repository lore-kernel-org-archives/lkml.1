Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYIAVTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYIAVTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 17:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYIAVSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 17:18:54 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:37142 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbYIAVSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 17:18:53 -0400
Date: Mon, 1 Sep 2008 23:18:10 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11271] BUG: fealnx in 2.6.27-rc1
Message-ID: <20080901211810.GA21777@electric-eye.fr.zoreil.com>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <N8SeMoDzuxC.A.xIG.OkbuIB@albercik> <3f9a31f40809011002k572450ffg90654912f3e1fa2a@mail.gmail.com> <20080901100649.59c1ab1f@infradead.org> <3f9a31f40809011027o34dbfccfh9ed82228938cb572@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40809011027o34dbfccfh9ed82228938cb572@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh <jaswinderlinux@gmail.com> :
[...]
> may be you are right, I have never noticed it earlier. But currently
> this is soo serious that it has totally screwed up my networking when
> I use fealnx based NICs.

Could you enable CONFIG_PRINTK_TIME and give Jeff's reversal suggestion
a try ?

I do not see where the patch would break. Would a broken clock trigger
a lot of spurious tx timeout ?

-- 
Ueimor
