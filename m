Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbXG1L7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbXG1L7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 07:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXG1L7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 07:59:48 -0400
Received: from main.gmane.org ([80.91.229.2]:37994 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbXG1L7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 07:59:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: Problems with reading DVD using 2.6.21.5
Date: Sat, 28 Jul 2007 14:04:32 +0200
Message-ID: <f8fb35$jfa$1@sea.gmane.org>
References: <fa.wwGTjo0zKd+GP1ok2NxTU1KXblw@ifi.uio.no> <46AAA0BE.5030102@shaw.ca> <f8err9$d27$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pd9e42cd1.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.5) Gecko/20070723 FirefoxSucks/9 SeaMonkey/1.1.3
In-Reply-To: <f8err9$d27$1@sea.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried to reproduce this bug by mounting/unmounting the drive several 
times.

It seems like this problem is caused, if the drive is at speed 0 after 
some time without access. In this situation, sometimes the drive seems 
to take a bit longer to speed up. Whenever it takes a bit longer, I get 
the error in dmesg and parts of the mounted disc are unreadable...

Any chance to get this debugged?

CU

Manuel

