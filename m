Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbYLNU4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbYLNU4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 15:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYLNU4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 15:56:06 -0500
Received: from main.gmane.org ([80.91.229.2]:45557 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYLNU4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 15:56:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Date: Sun, 14 Dec 2008 20:55:53 +0000 (UTC)
Message-ID: <gi3rsp$iog$2@ger.gmane.org>
References: <gi247o$iog$1@ger.gmane.org> <4944AAFD.1060105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: d193-213-184.home3.cgocable.net
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008 22:43:09 -0800, Justin P. Mattock wrote:

> not too sure what the situation is for you, but if  you're deciding to
> stay with 2.6.24.* then look through the commits to see if this has been
> resolved. if not then load the latest git to see if this has been
> committed for the fix.

Well, I've just built and installed 2.6.28-rc8 and the problem persists.

> if it's just debugging then hmm.. maybe ssh (but
> you don't have intranet upon wakeup);

Right.  It's for all intents and purposes "dead" on resume.  Even 
CAPSLOCK on the console does not active the LED.

> maybe usb or some other hard wired
> mechanism?

I'd hoped to do serial console, but sadly, this laptop, like many today 
doesn't have even a single serial port.  I had considered a USB serial 
and making it console (if even possible) but now I am just spending more 
money trying to get this stupid laptop working.  ~sigh~

b.

