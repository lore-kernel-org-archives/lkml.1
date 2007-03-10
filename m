Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbXCJWpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbXCJWpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932354AbXCJWpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:45:18 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60708 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbXCJWpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:45:17 -0500
Date: Sat, 10 Mar 2007 23:45:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070310224534.GA3150@uranus.ravnborg.org>
References: <20070310160542.21cdb968@localhost> <20070310160614.GB10230@cvg> <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost> <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr> <20070310175058.GA19878@cvg> <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr> <20070310212730.GA2577@uranus.ravnborg.org> <Pine.LNX.4.61.0703102234210.26332@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703102234210.26332@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 10:34:41PM +0100, Jan Engelhardt wrote:
> 
> On Mar 10 2007 22:27, Sam Ravnborg wrote:
> >On Sat, Mar 10, 2007 at 07:23:41PM +0100, Jan Engelhardt wrote:
> >> 
> >> Whether the 'working config file path' should change when you do
> >> 'Save as Alternate' or not, is a menuconfig axiom. Ask Sam Ravnborg
> >> if you want it changed :-)
> >
> >Current behaviour is not logical but on the other hand I do not
> >see a big need to make it so.
> >It seems that people very seldom uses "save alternate" anyway.
> >
> >But patches are welcome.
> 
> ^_^ The patch has already been posted, has not it?
No.
Either we keep current behaviour or we change to the "normal"
behaviour with a "Save as..." as know from all other programs.

	Sam
