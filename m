Return-Path: <linux-kernel-owner+w=401wt.eu-S1750837AbXCEQIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837AbXCEQIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXCEQIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:08:21 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:39711 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbXCEQIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:08:20 -0500
Date: Mon, 5 Mar 2007 17:07:31 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: FN <zzzz444@ml1.net>
cc: Oleg Verych <olecom@flower.upol.cz>, linux-kernel@vger.kernel.org
Subject: Re: module builds need improvement / top Makefile not good enough
In-Reply-To: <1173102794.12256.1177759349@webmail.messagingengine.com>
Message-ID: <Pine.LNX.4.61.0703051707130.24366@yvahk01.tjqt.qr>
References: <1172855662.23830.1177403935@webmail.messagingengine.com>  
 <E1HNyYT-00086z-27@flower> <1173102794.12256.1177759349@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 5 2007 05:53, FN wrote:
>
>| > I am unhappy with the direction the 2.6 kernel builds have taken.
>| > Very much like Micro$loth DDKs we (linux users) are being forced to
>| > build modules by plugging into a framework that doesn't respect the
>fine
>| > aspects of dependency generation and analysis.
>| 
>| Ideas in form of patches are accepted,
>
>I think that one of the bigger firms that support linux, like IBM,
>Redhat,
>Suse, ought to hire a contractor to redesign kbuild and get the linux
>community involved.

The fact that they did not so far means they are fine with Kbuild.


Jan
-- 
