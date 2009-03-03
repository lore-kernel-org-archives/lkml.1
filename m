Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbZCCRXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbZCCRXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 12:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbZCCRXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 12:23:45 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:36312 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbZCCRXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 12:23:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QGtWe7t0ynHkk9Am/6EC4UrhgrBJXMatZ+Z3uTQBEoF6DpumjgyWVDsUXu7u6lLHHF
         meHshTGF/BAH5UVRRgVU0x4Pc8QpRdQyLRCwAJptiDWwXzAvdqDt6ICiX/nWNPVwThs5
         DjM/xLwB9uAJp5eMfot65VCr1KuqT30U8ogCM=
MIME-Version: 1.0
In-Reply-To: <49AD4C74.1060704@s5r6.in-berlin.de>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>
	 <49ACC6B0.409@garzik.org>
	 <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>
	 <20090303072637.GB4440@kroah.com>
	 <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
	 <49AD4C74.1060704@s5r6.in-berlin.de>
Date: Tue, 3 Mar 2009 09:23:41 -0800
Message-ID: <43e72e890903030923v27c47f5anc184c0e8085bc5c1@mail.gmail.com>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus' tree"
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 7:27 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Luis R. Rodriguez wrote:
>> On Mon, Mar 2, 2009 at 11:26 PM, Greg KH <greg@kroah.com> wrote:
>>> Who are these "people" that you are trying to convince?
>>
>> OK small silly example is convincing distributions it may be a good
>> idea to carry linux-next kernel packages as options to users to
>> hopefully down the road reduce the delta between what they carry and
>> what is actually upstream.
>
> Distros would do their users a bigger favour if they didn't just dump a
> random new driver into their kernel package, but if they instead (or in
> addition) support the process to get new drivers into the mainline.
>
> It's a favour to their users because maintenance in mainline generally
> means better quality.  (Less drivers which break suspend/resume etc. pp.).
>
> It's also a favour to themselves because the maintenance of their kernel
> as a whole will cost less if it is a stabilized derivative of the
> mainline instead of an unstable (and merely potential) predecessor of
> the mainline.

I don't think I was very clear in what I meant about "carrying
linux-next kernel packages as an option". What I meant was carrying it
just as an option for those users who want to test bleeding edge
without compiling their own linux-next, _not_ to merge linux-next
things into their own default kernel release and shove it down users
throats.

  Luis
