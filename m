Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZKMKUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZKMKUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbZKMKUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:20:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47156 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbZKMKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:20:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AFD32F1.6030902@s5r6.in-berlin.de>
Date: Fri, 13 Nov 2009 11:20:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firedtv: fix regression: tuning fails due to bogus error
 return
References: <4ADA149E.1070704@s5r6.in-berlin.de> <4ADA26D0.6010108@s5r6.in-berlin.de> <tkrat.de5abfc32fa5476d@s5r6.in-berlin.de> <4AFD306F.1020802@s5r6.in-berlin.de>
In-Reply-To: <4AFD306F.1020802@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> ...the firedtv-avc.c part of the patch vanished when you committed it.

It was still there in the linuxtv-commits message of the respective
Mercurial commit, BTW.  Something wrong with the hg to git workflow?
-- 
Stefan Richter
-=====-==--= =-== -==-=
http://arcgraph.de/sr/
