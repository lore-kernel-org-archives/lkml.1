Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYLNIHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYLNIHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYLNIHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:06 -0500
Received: from main.gmane.org ([80.91.229.2]:56773 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYLNIHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: Linux 2.6.27.9
Date: Sun, 14 Dec 2008 09:06:53 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2008.12.14.08.06.53.334750@wizards.de>
References: <20081214001029.GA915@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-136-62.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008 16:10:29 -0800, Greg KH wrote:

> We (the -stable team) are announcing the release of the 2.6.27.9 kernel.

This is still missing the fix for the regression from .7 to .8 that I
reported here:
http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/00006.html

The fix is here:
http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/00998.html

Been running that on top of -stable and it does fix the problem. It also
seems to work for other people. Is there some particular reason why this
was not included? I tested and cc'ed stable@ for a reason. :(

-h


