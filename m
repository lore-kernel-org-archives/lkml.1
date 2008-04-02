Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYDBKgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYDBKgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYDBKfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:35:53 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39437 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYDBKfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:35:52 -0400
Message-ID: <47F36168.5000702@s5r6.in-berlin.de>
Date: Wed, 02 Apr 2008 12:35:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Pieter Palmers <pieterp@joow.be>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH upate] iso transmit cycle skip patch
References: <47E18163.1080200@joow.be> <tkrat.0d0791eae8f1fc6c@s5r6.in-berlin.de> <47F341CB.7050406@joow.be>
In-Reply-To: <47F341CB.7050406@joow.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pieter Palmers wrote:
> I have to admit that I didn't write the patch with the idea of mainline 
> inclusion in mind, but merely as a proof of concept. Therefore I'd like 
> to check it again to ensure that it is ok for worldwide distribution ;).

Don't be shy. :-)  It's a safe bet that nobody else is going to work on
this transmit FIFO underflow issue.

> However I'm swamped with work at the moment and can't do this before 2nd 
> half of next week.

Take your time.  We could also submit it in an early 2.6.26-rc stage or,
if that doesn't work out, after 2.6.26.
-- 
Stefan Richter
-=====-==--- -=-- ---=-
http://arcgraph.de/sr/
