Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYGUH5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYGUH5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbYGUH5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:57:14 -0400
Received: from main.gmane.org ([80.91.229.2]:34065 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbYGUH5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:57:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: Kernel version : what about s.yy.ww.tt scheme ?
Date: Mon, 21 Jul 2008 07:57:03 +0000 (UTC)
Message-ID: <loom.20080721T074322-56@post.gmane.org>
References: <loom.20080717T083755-676@post.gmane.org> <alpine.LNX.1.10.0807171140030.18697@fbirervta.pbzchgretzou.qr> <20080720181426.GA29189@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.151.128.130 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.16) Gecko/20080702 Firefox/2.0.0.16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w <at> 1wt.eu> writes:


> 
> also, causes trouble when stable releases cross a year boundary, or
> when there are several ones in a week. The stable release should
> only be a counter, not a date.
> 
> Willy
> 
> 

If there are more stable releases in a week, you could put a release counter
after a dash, say : 2.08.30.40-[2...X]

If stable continues to be used and leaps over to next year, put another .yy.ww
section : 2.08.30.09.02

OK I know that's long, but easy to expand if needed, just be sure to separate
date pieces with dots and counters with dashes. Or...

maybe use them the other way round - the current scheme uses counters separated
by dots, so maybe the new could do ss.yy-ww-tt[[-yy]-ww][.X]] ? Like
2.08-30-40.2 ? 2.08-30-09-02.2 ? But this seems odd, even to me ;)

el es

