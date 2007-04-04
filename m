Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXDDV63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXDDV63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXDDV62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:58:28 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:33906 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXDDV61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Sf6SdBwCbk/QABrJLL0z9J7wgyayhVl2E1WI4XMrOJzK3aEd/CMsMCdCvLE9cr2KHuVI4vVtL0gjAdlKbqQ/s0T5rlDMsFq7JyN4WYTOOk8sHeiaZfXYzwaR0gMjkLPcUbsMJ9alRbhzPehqpSs3NWLoirwHkiRz9EmgE7UxH4c=
Message-ID: <f9be06770704041458v53b52a4er95b2f6e86e88615@mail.gmail.com>
Date: Wed, 4 Apr 2007 17:58:21 -0400
From: "Karl Pickett" <karl.pickett@gmail.com>
To: "Vincent Vanackere" <vincent.vanackere@gmail.com>
Subject: Re: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
Cc: "=?ISO-8859-1?Q?=C9ric_Piel?=" <Eric.Piel@tremplin-utc.net>,
       linux-kernel@vger.kernel.org, inux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <65258a580704041416v61c6f1a5qfd54cc98bd4e8300@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
	 <461357D8.8060608@tremplin-utc.net>
	 <65258a580704040145m6eb7108frfa8197d3b88e207a@mail.gmail.com>
	 <f9be06770704040637k419a7fd7t2cdd52186d91ad5f@mail.gmail.com>
	 <f9be06770704040821h6d96e703hf405335fa73f289b@mail.gmail.com>
	 <65258a580704041352q664f5da2xeaeec1a82819d9ef@mail.gmail.com>
	 <461412C2.8090201@tremplin-utc.net>
	 <65258a580704041416v61c6f1a5qfd54cc98bd4e8300@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Vincent Vanackere <vincent.vanackere@gmail.com> wrote:
> On 4/4/07, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> > 04/04/2007 10:52 PM, Vincent Vanackere wrote/a écrit:
> > > +        unsigned long first_jiffies;
> >     ^^^^^^^^ space warning!
> >
> > Sorry for being annoying ;-)
> > Eric
> >
>
> Indeed you are    8-)
> ... new version attached ...
>
> Best regards,
>
> Vincent
>
>

Works great for me.  I can now give it a hard press and not cause a
repeat.  It's nice that you can  just set repeat_delay to 0 to get the
identical previous behavior, in case anybody was in love with that.

The spaces were probably my fault, I sent it from a machine with
expandtab on (don't ask :)



-- 
Karl Pickett
The most wasted of all days is one without laughter.—E.E. Cummings
