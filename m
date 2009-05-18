Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZERMcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZERMcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZERMcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:32:31 -0400
Received: from india.einfochips.com ([203.88.139.151]:19314 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750795AbZERMcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:32:31 -0400
Message-ID: <4A115480.60003@einfochips.com>
Date: Mon, 18 May 2009 17:58:48 +0530
From: Viral Mehta <viral.mehta@einfochips.com>
Organization: eIbfochips Ltd.
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: gcc compilation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was compiling 2.6.29.7 kernel but it stopped as my system had gcc 
version 4.1.1.
There was some bug with respect to __weak attribute in gcc 4.1.[01]. So, 
I started installing newer gcc 4.3.0.

That was a history part. Now, I have a query.

If I am installing gcc 4.3.0. It will be compiled using gcc 4.1.0 as I 
have that installed on my PC. Now, gcc 4.1.0 has several BUGS and so 
compilation of gcc 4.3.0 will not happen correctly. How this situation 
is handled normally ??
-- 
Thanks, Viral Mehta, Embedded Software Engineer, www.einfochips.com
