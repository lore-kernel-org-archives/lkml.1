Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbYDLMnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbYDLMnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbYDLMnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:43:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4641 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757434AbYDLMnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:43:20 -0400
Date: Sat, 12 Apr 2008 14:33:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Wappler Marcel <Marcel.Wappler@bridgeco.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Starting point: Suspend to RAM on embedded devices?
Message-ID: <20080412123352.GC4492@ucw.cz>
References: <83116F0A4FF67A4F97BA0B6E408C48E301E96208@zuerich.BC-Int.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E301E96208@zuerich.BC-Int.NET>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-04-10 10:14:30, Wappler Marcel wrote:
> Hi all,
> 
> I am looking for ways to let an ARM9 based embedded device running Linux go to a "suspend to RAM" like mode. In my opinion this
> could enable a HIFI equipement like "power-off" and "power-on" feeling with quick response (less than 2 seconds) and much less power
> consumption in the standby mode than during normal operation.
> 
> - Is there public available documentation about APM like features on ARM architectures?
> - Is there a mainstream Linux platform (best if also ARM9 based) which has achieved this already?

Sharp zaurus, olpc, nokia n810...

And yes, suspend/resume is quite fast, ~2sec on zaurus, 300msec on
olpc.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
