Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYGVAf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYGVAf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYGVAfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:35:50 -0400
Received: from tihlde.org ([158.38.48.10]:53479 "EHLO colargol.tihlde.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbYGVAft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:35:49 -0400
Message-ID: <48852B65.9060907@tihlde.org>
Date: Tue, 22 Jul 2008 02:35:49 +0200
From: Roy Sindre Norangshol <norrs@tihlde.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
References: <48840021.60001@tihlde.org>
In-Reply-To: <48840021.60001@tihlde.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 84.48.62.25
X-SA-Exim-Mail-From: norrs@tihlde.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - 2.6.25.7
X-SA-Exim-Version: 4.2.1 (built Fri, 20 Jun 2008 19:33:36 +0200)
X-SA-Exim-Scanned: Yes (on colargol.tihlde.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roy Sindre Norangshol wrote:
> I tried upgrading to 2.6.26 release - but server died again on 
> saturday, so going to check
> logs later today (Monday) to see if it's another kernel bug popping up.
No logs after second crash with 2.6.26 kernel, and nothing useful to 
pickup from screen since it frooze..
Back to 2.6.18 I go..
> *snip*
> motherboard of type P35 chipset, motherboard P35C-DS3 [3] (I think) by 
> Gigabyte.
> *snip*
It was EP35-DS3R by Gigabyte.
>
> I'll provide more hardware information when I reboot the server, so I 
> can run lspci, lshw, dpkg -l to provide
> you guys with more information as I guess that would be nice. Anything 
> else I should run?
lshw,lspci and such are available here: http://norrs.no/kroton2/

Hope it is of any use.

--
Roy Sindre Norangshol
