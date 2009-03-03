Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZCCSOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZCCSOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCCSO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:14:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34039 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZCCSO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:14:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49AD7361.308@s5r6.in-berlin.de>
Date: Tue, 03 Mar 2009 19:13:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus' tree"
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>	 <49ACC6B0.409@garzik.org>	 <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>	 <20090303072637.GB4440@kroah.com>	 <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>	 <49AD4C74.1060704@s5r6.in-berlin.de> <43e72e890903030923v27c47f5anc184c0e8085bc5c1@mail.gmail.com>
In-Reply-To: <43e72e890903030923v27c47f5anc184c0e8085bc5c1@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Tue, Mar 3, 2009 at 7:27 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Luis R. Rodriguez wrote:
>>> OK small silly example is convincing distributions it may be a good
>>> idea to carry linux-next kernel packages as options to users to
>>> hopefully down the road reduce the delta between what they carry and
>>> what is actually upstream.
>> Distros would do their users a bigger favour if [...]
> 
> I don't think I was very clear in what I meant about "carrying
> linux-next kernel packages as an option". What I meant was carrying it
> just as an option for those users who want to test bleeding edge
> without compiling their own linux-next, _not_ to merge linux-next
> things into their own default kernel release and shove it down users
> throats.

Sorry, I meant "bigger favour" relative to carrying an own delta of
considerable size.

Packaging linux-next would be fine if the workload isn't a problem for
the packager.  As pointed out elsewhere, there are caveats with
linux-next (e.g. a functionality which was in it yesterday could be gone
today because of a merge issue), but that's the nature of bleeding edge
of course.
-- 
Stefan Richter
-=====-==--= --== ---==
http://arcgraph.de/sr/
