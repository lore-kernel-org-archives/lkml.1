Return-Path: <linux-kernel-owner+w=401wt.eu-S1750977AbXCJVf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbXCJVf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXCJVf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:35:27 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:46935 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXCJVf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:35:26 -0500
Date: Sat, 10 Mar 2007 22:34:41 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
In-Reply-To: <20070310212730.GA2577@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.61.0703102234210.26332@yvahk01.tjqt.qr>
References: <20070310160542.21cdb968@localhost> <20070310160614.GB10230@cvg>
 <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost>
 <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr> <20070310175058.GA19878@cvg>
 <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr> <20070310212730.GA2577@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 10 2007 22:27, Sam Ravnborg wrote:
>On Sat, Mar 10, 2007 at 07:23:41PM +0100, Jan Engelhardt wrote:
>> 
>> Whether the 'working config file path' should change when you do
>> 'Save as Alternate' or not, is a menuconfig axiom. Ask Sam Ravnborg
>> if you want it changed :-)
>
>Current behaviour is not logical but on the other hand I do not
>see a big need to make it so.
>It seems that people very seldom uses "save alternate" anyway.
>
>But patches are welcome.

^_^ The patch has already been posted, has not it?


Jan
-- 
