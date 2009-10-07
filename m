Return-Path: <linux-kernel-owner+w=401wt.eu-S934395AbZJGVCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395AbZJGVCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934348AbZJGVCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:02:48 -0400
Received: from xenotime.net ([72.52.64.118]:52303 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933842AbZJGVCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:02:48 -0400
Message-ID: <4ACD021A.9020509@xenotime.net>
Date: Wed, 07 Oct 2009 14:03:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joe moo <starquestnerd@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux autobuild Makefile to assist in autobuilding the kernel
 (eg. 	via a cronjob)
References: <296622aa0910071352v16ba4302y2c5ae50f51924026@mail.gmail.com>
In-Reply-To: <296622aa0910071352v16ba4302y2c5ae50f51924026@mail.gmail.com>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe moo wrote:
> I hope you like it you can look at it and fork it here:
> http://gist.github.com/204431
> 
> Basically it automates a lot of things and it ONLY wraps around the
> current Makefile to avoid reinventing the wheel. It runs git pull to
> update and (by default) builds an x86 system configured with
> allmodconfig! I acctually wrote this a few months ago...
> --

Hi,
The [download] button does not work and git clone tells me:
fatal: The remote end hung up unexpectedly

:(
