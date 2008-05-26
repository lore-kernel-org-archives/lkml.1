Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYEZRMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYEZRMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbYEZRMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:12:45 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:58719 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYEZRMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:12:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Mon, 26 May 2008 19:11:59 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805261453.01658.mb@bu3sch.de> <orprr9uh53.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orprr9uh53.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805261912.00422.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 May 2008 19:09:12 Alexandre Oliva wrote:
> On May 26, 2008, Michael Buesch <mb@bu3sch.de> wrote:
> 
> > On Monday 26 May 2008 05:13:18 Alexandre Oliva wrote:
> >> On May 25, 2008, Michael Buesch <mb@bu3sch.de> wrote:
> >> 
> >> > One additional thing is to make sure the usability of the whole stuff
> >> > is not reduded.
> >> 
> >> Removing support for slashes wouldn't reduce usability.  It would be
> >> no more than silly policy (and ego?) enforcement.
> 
> > I the other mail you say that the string is _not_ a filename.
> 
> I do, and I stand by that claim, that is not backed by documentation,
> but rather by peeking at the implementation.

Right.

> > So why do we want to remove the slash from the allowed charset, if
> > the string is not a filename?
> 
> Exactly my point.  I don't know any reason to do that.  It appears to
> be just silly policy (and ego) enforcement.

Ok I see. It seems I misunderstood your mail. Sorry for that.

-- 
Greetings Michael.
