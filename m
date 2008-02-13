Return-Path: <linux-kernel-owner+w=401wt.eu-S1765333AbYBMWub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765333AbYBMWub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbYBMWuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:50:23 -0500
Received: from onyx.ip.pt ([195.23.92.252]:57247 "EHLO mail.isp.novis.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbYBMWuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:50:22 -0500
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
From: Ricardo Cerqueira <v4l@cerqueira.org>
To: linux-dvb-maintainer@linuxtv.org
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0802131349400.6264@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota>
	<Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
	<20080213155352.06d966cd@gaivota>
	<Pine.LNX.4.58.0802131025440.6264@shell2.speakeasy.net>
	<1202935004.17260.54.camel@localhost.localdomain>
	<Pine.LNX.4.58.0802131349400.6264@shell2.speakeasy.net>
Organization: video4linux
Date: Wed, 13 Feb 2008 22:50:18 +0000
Message-Id: <1202943018.4064.37.camel@frolic>
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8)
X-MSTD-Info: clean
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 13:53 -0800, Trent Piepho wrote:
> On Wed, 13 Feb 2008, Ricardo Cerqueira wrote:
> > On Wed, 2008-02-13 at 10:45 -0800, Trent Piepho wrote:
> > > On Wed, 13 Feb 2008, Mauro Carvalho Chehab wrote:
> > > > On Tue, 12 Feb 2008 21:21:43 -0800 (PST)
> > > > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > >
> > Read the code that was actually committed: here's a helpful link:
> >
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=41a93616082af630e7242cba766a161d7847560b
> 
> I did.  Looks like there is a race on access to core->active_ref.

You're right, I missed that. A patch has already been sent to the
V4L/DVB list.

> You could also CC the relevant parties.  Unless you're hoping they won't
> notice something.

Sorry, but no. I actively try *not* to send duplicate e-mails to people
unless they specifically request it.

--
RC


