Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbYDDOhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbYDDOhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYDDOhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:37:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:59177 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbYDDOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=n2I2dKW1Lp1jz68tbqTGrOy4q6Ikl7Xgo15Gj94Z7BQK4DQqNUufWwTX3fspe0XcJSLbGXmUF+T2w2qDN3XlqtX4Ua+8RJhwogv48X9Hll/7lPlnP1MDalcmaHAl6w+2qNLvJNBfxiM+AsylYd2mxMVeB05PUeh/OFIPDkKL2Fo=
Message-ID: <b6c5339f0804040737k38839c71l19972e73325a48c4@mail.gmail.com>
Date: Fri, 4 Apr 2008 10:37:31 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: ASUS ScreenDuo
Cc: "Xavier Bestel" <xavier.bestel@free.fr>,
       "Alan Stern" <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080403212427.GE24239@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0804031506300.7376-100000@iolanthe.rowland.org>
	 <1207251545.24007.3.camel@bip.parateam.prv>
	 <b6c5339f0804031358q46379223ud4839c0de01290cf@mail.gmail.com>
	 <20080403212427.GE24239@csclub.uwaterloo.ca>
X-Google-Sender-Auth: 77fff95f611f6803
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 5:24 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>  Well apparently vista expects the device to support running programs
>  written in .NET Micro Framework.  Maybe that is some JVM like thingy.

If it is supposed to implement the MS SideShow API, then that would be
the .NET VM (i.e. C#).  My 10 second googling turned up some info about
that but I couldn't find a definition of how the hardware interface
for such devices is supposed to work.  There's some XML-laden software
API but it seemed to be transport agnostic.

-Bob
