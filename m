Return-Path: <linux-kernel-owner+w=401wt.eu-S934530AbZJNPbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934530AbZJNPbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934452AbZJNPbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:31:25 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:14824 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934311AbZJNPbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=evsYkHgwd01JdeE5Mb14v0NykearEptwa0Rlf29t7pMLUPbs4Jn64vtzzDLmRQQSLE
         LMYtfh4aQd0fkjlED5NM6B7PgxvF5P0udv8cQsYbrNNTFfINnHTdtsZ1DvTvxILkNAJp
         EAAWV3JP/iFHmBV/iSix/2z3xsZNAO//0AWmw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Wed, 14 Oct 2009 17:28:21 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc2-00279-g2ffa5fe; KDE/4.3.1; x86_64; ; )
Cc: Dan Williams <dcbw@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910141652.41041.bzolnier@gmail.com> <20091014145605.GE2890@tuxdriver.com>
In-Reply-To: <20091014145605.GE2890@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200910141728.21491.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009 16:56:05 John W. Linville wrote:
> On Wed, Oct 14, 2009 at 04:52:40PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 14 October 2009 16:09:24 John W. Linville wrote:
> > > On Tue, Oct 13, 2009 at 11:57:57PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > > Several months later (after all current users are happy with the improved
> > > > drivers) the old drivers will be removed from staging..
> > > 
> > > I _really_ hope this isn't the standard.  By that measure, nothing
> > > will ever leave staging as _someone_ will always have some use case
> > > that makes the other driver better for them.
> > 
> > Doesn't seem to be the case with all other drivers except wireless ones
> > and the only real reason why wireless ones are so special is because of:
> > 
> > "But then there's the users, who bitch about everything and simply do
> > not understand what it is at stake.
> > 
> > And all this is becoming way too messy for us to handle.
> > 
> > Personally all I see around me is people bitching and complaining, and
> > no code being ported."
> > 
> > attitude which pretty much explains the problem..
> > 
> > Please adjust the process to fix the problem yourself or if you do not
> > want to do it just make the room for people who do.
> 
> Alright Bartlomiej, you've had your say.  Perhaps you should go about
> your business now.
> 
> John
> 
> P.S. For the record, the "But then there's the users..." quote is
> from someone else...

..but you're still fine with its content, right?

I also wonder who is really taking advantage of who here (your other mail)..

You're holding users as hostages to pressure vendors to fund your projects
and try to lure outside developers with the lovely perspective of doing
the hardest parts of said projects.

I don't have a have a problem with it personally as long as people accept
the competition..  but instead of working on _their_ projects they go around
screaming at everybody who does not want to spin inside the great process
designed by them..
