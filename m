Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYBPLTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYBPLTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYBPLTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:19:00 -0500
Received: from qmta04.westchester.pa.mail.comcast.net ([76.96.62.40]:54534
	"EHLO QMTA04.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbYBPLTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:19:00 -0500
X-Authority-Analysis: v=1.0 c=1 a=TEGKNp2qDdgA:10 a=YXkDNHkUlIuBYAp5KlYA:9
 a=ZDO1xELfopL4MeqzdPDKiIOCIqMA:4 a=uv1ck3d6JtEA:10
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: elendil@planet.nl, Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
References: <1203123219.6176.36.camel@popeye>
	 <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 05:18:46 -0600
Message-Id: <1203160726.16186.8.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri - 

OK - I will confirm that I have been running with CONFIG_GROUP_SCHED
set.  I have turned it off via menuconfig (which also gets rid of a
couple of other options like CONFIG_USER_SCHED and
CONFIG_FAIR_GROUP_SCHED) and I am performing a kernel build from clean
sources.

Get back to you in a while

Chris



On Sat, 2008-02-16 at 12:03 +0100, Jiri Kosina wrote:
> On Fri, 15 Feb 2008, Chris Holvenstot wrote:
> 
> > A number of corrispondents on this list offered troubleshooting
> > suggestions, most of which centered arund the high performance timer.
> > If you too feel that the issue you are seeing might be releated to the
> > one I saw the following clips from the email I received might be of
> > interest to you.
> > >From Jiri Kosina:
> > It could be some timing problem. Does this happen also in console, or 
> > only when running X?
> 
> Chris,
> 
> could you please check whether you have CONFIG_GROUP_SCHED turned on, and 
> if so, try if turning it off fixes the problems?
> 

