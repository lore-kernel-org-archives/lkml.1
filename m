Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab0BPPan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:30:43 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33866 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab0BPPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 10:30:41 -0500
Message-ID: <4B7AB9C0.6070402@kernel.org>
Date: Tue, 16 Feb 2010 07:29:04 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: tytso@mit.edu, Jean Delvare <khali@linux-fr.org>,
       Pavel Machek <pavel@ucw.cz>, mirrors@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare> <20100214170724.GE1578@ucw.cz> <20100214200803.4b2348ce@hyperion.delvare> <20100215151522.GI5337@thunk.org>
In-Reply-To: <20100215151522.GI5337@thunk.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Tue, 16 Feb 2010 07:29:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 07:15 AM, tytso@mit.edu wrote:
> On Sun, Feb 14, 2010 at 08:08:03PM +0100, Jean Delvare wrote:
>> On Sun, 14 Feb 2010 18:07:24 +0100, Pavel Machek wrote:
>>> Hi!
>>>
>>>> As a matter of fact, I am advocating the use of xz while I don't have
>>>> it installed on most of my machines. I really don't see this as a
>>>> blocker.
>>>
>>> Eh?
>>>
>>> Making many people around the world install uncommon tool is not
>>> something that should be done lightly.
>>
>> It's pretty obvious that xz will become popular quickly, at least on
>> Linux and BSD systems, much like bz2 is today. I'm not asking people to
>> start using ClearCase ;) xz will supersede bz2, it's only a matter of
>> time. I see no problem in being one of the early adopters.
> 
> If by "quickly" you mean 'ten years', sure, maybe.  Keep in mind that
> there are people where who are still using RHEL 3, and some of them
> might want to download from ftp.kernel.org.  So those people who are
> suggesting that we replace .gz files with .xz on kernel.org are
> *really* smoking something good.
> 
> People who think xz are good should be working to get it installed by
> default into the community and then enterprise distro's, first....
> 
> 						- Ted

As a note xz is available via EPEL for Redhat Enterprice Linux 5 and
anything that's derived from that.  Doesn't seem to be available,
directly, for 4 or lower.  Not sure on Suse, and Debian's already been
mentioned.  Just trying to do a quick survey of what's out there already.

- John 'Warthog9' Hawley
