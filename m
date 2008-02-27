Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbYB0A34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbYB0A34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932893AbYB0A32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:29:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52563 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbYB0A31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:29:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C4AEDC.80600@s5r6.in-berlin.de>
Date: Wed, 27 Feb 2008 01:29:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Romano Giannetti <romanol@upcomillas.es>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Intel 945GM: 2.6.25-rc3 report (with a possible regression)
References: <1204056556.7745.22.camel@localhost>
In-Reply-To: <1204056556.7745.22.camel@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Romano Giannetti wrote:
> 1) The minor regression is that I cannot have any more a correct
> console. I tried a lot of combinations, but without a framebuffer,
> console is garbled by ubuntu splash and/or X.

Are you sure that this is a kernel regression, not a xf86-video-i810 
regression?

(On Gentoo, switching from X to console works with xf86-video-i810-2.1.1 
but results in a black screen with xf86-video-i810-2.2.0.90.)
-- 
Stefan Richter
-=====-==--- --=- ==-==
http://arcgraph.de/sr/
