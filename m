Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYELWuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYELWuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYELWuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:50:10 -0400
Received: from xsmtp0.ethz.ch ([82.130.70.14]:12890 "EHLO XSMTP0.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbYELWuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:50:09 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 18:50:09 EDT
Message-ID: <4828C607.9020107@gmx.de>
Date: Tue, 13 May 2008 00:34:47 +0200
From: Dieter Ries <clip3@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
To: kakadu84@comcast.net
CC: linux-kernel@vger.kernel.org
Subject: Re: Command-line tools for stress-testing SATA hard disks (and libata)
References: <4828C05E.1010201@comcast.net>
In-Reply-To: <4828C05E.1010201@comcast.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2008 22:34:53.0869 (UTC) FILETIME=[65E9BDD0:01C8B480]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bradley Chapman schrieb:
> Can anyone here recommend a command-line disk benchmark or stress test 
> utility that doesn't need to be run in X (allowing me to test with 
> untainted kernels) and would be capable of producing a variety of I/O 
> access patterns that could trigger the errors I've seen during normal 
> usage? 

Why don't you just use the vesa driver and use your stress test utility 
in X?

> Brad

cu
	Dieter
