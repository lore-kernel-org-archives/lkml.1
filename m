Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbYD2Jsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbYD2Jsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYD2JsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:48:22 -0400
Received: from wmproxy1-g27.free.fr ([212.27.42.91]:9996 "EHLO
	wmproxy1-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbYD2JsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:48:21 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 05:48:21 EDT
Message-ID: <1209462094.4816ed4e93977@imp.free.fr>
Date: Tue, 29 Apr 2008 11:41:34 +0200
From: sancelot@free.fr
To: linux-kernel@vger.kernel.org
Subject: detecting kernel mem leak
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 213.41.233.134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed the memory was growing without doing anything in my system ....after
some investigations , it looks like some kernel components may be involved in
this problem.


I would like to know if there is a way to monitor activity of memory (de)alloc
of the kernel in order to target which partof the system/kernel could do this..?

Best Regards
S.Ancelot







