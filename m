Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZLARoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZLARoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZLARoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:44:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57927 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZLARoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QqHOU+XM3vzjWXDvWPhOVWT9wIGYvrvU8z3lTwcj4BeURAwl//Br9s2nMVPYSEu6/e
         zUzy5eqfJILxGwYuIhA5OBamHgi8jDw1CQ3cVIPjfpZkZ2oo1vXcEJv/jICaj3j2E2t4
         BTrCug5KrjXy1iPwXcY79KkcJbfzMUF1x7byg=
Message-ID: <4B1555D4.70704@gmail.com>
Date: Tue, 01 Dec 2009 18:43:48 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Joe Perches <joe@perches.com>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: warning: massive change to conditional coding style in net?
References: <4B13A025.7000103@gmail.com> <1259603798.29779.293.camel@Joe-Laptop.home> <4B153F9B.7050502@gmail.com>
In-Reply-To: <4B153F9B.7050502@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson wrote, On 12/01/2009 05:08 PM:

> But more important, at least to my thinking, is keeping patches simple
> by conforming to the *existing* style in the section of code.  No
> sweeping changes!

How about new sections in between transit smoothly from one style
to another? (Or 50/50?)

Jarek P.
