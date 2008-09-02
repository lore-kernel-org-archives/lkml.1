Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYIBVxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYIBVxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYIBVxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:53:07 -0400
Received: from blu0-omc1-s34.blu0.hotmail.com ([65.55.116.45]:2990 "EHLO
	blu0-omc1-s34.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbYIBVxG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:53:06 -0400
Message-ID: <BLU122-W542897329D9AB74E77D73DA5F0@phx.gbl>
X-Originating-IP: [84.216.36.12]
From: Peter Hallberg <hallberg68@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Request: Remove duplicate file names in the kernel source
Date: Tue, 2 Sep 2008 23:53:04 +0200
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 02 Sep 2008 21:53:04.0174 (UTC) FILETIME=[46B26CE0:01C90D46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

The netfilter sources in the Linux Kernel contains a number of files that is duplicates expect for the case, like foo.c and FOO.c, this creates a problem when untaring the kernel source on a filesystem that doesn't support it like the common Windows file systems, sometimes you have the need to study the kernel source on other systems and it really is unecessary and confusing to have this naming so I would like to ask you to change it, below is a list of the files:

include\linux\netfilter\xt_connmark.h
include\linux\netfilter\xt_dscp.h
include\linux\netfilter\xt_mark.h
include\linux\netfilter\xt_rateest.h
include\linux\netfilter\xt_tcpmss.h
include\linux\netfilter_ipv4\ipt_connmark.h
include\linux\netfilter_ipv4\ipt_dscp.h
include\linux\netfilter_ipv4\ipt_ecn.h
include\linux\netfilter_ipv4\ipt_mark.h
include\linux\netfilter_ipv4\ipt_tcpmss.h
include\linux\netfilter_ipv4\ipt_tos.h
include\linux\netfilter_ipv4\ipt_ttl.h
include\linux\netfilter_ipv6\ip6t_hl.h
include\linux\netfilter_ipv6\ip6t_mark.h
net\ipv4\netfilter\ipt_ecn.c
net\ipv4\netfilter\ipt_ttl.c
net\ipv6\netfilter\ip6t_hl.c
net\netfilter\xt_connmark.c
net\netfilter\xt_dscp.c
net\netfilter\xt_mark.c
net\netfilter\xt_rateest.c
net\netfilter\xt_tcpmss.c

_________________________________________________________________
Hetaste modetipsen & härligaste skönhetstesterna!
http://salongk.msn.se/