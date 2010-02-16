Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab0BPPQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:16:01 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45765 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab0BPPQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 10:16:00 -0500
Message-ID: <4B7AB624.5060507@kernel.org>
Date: Tue, 16 Feb 2010 07:13:40 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
CC: Steve French <smfrench@gmail.com>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Avi Kivity <avi@redhat.com>,
       Jean Delvare <khali@linux-fr.org>, users@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [kernel.org users] [kernel] Re: XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	 <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>	 <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare>	 <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare>	 <4B767810.5020707@s5r6.in-berlin.de> <4B767C67.7060701@redhat.com>	 <alpine.LNX.2.01.1002131233450.30803@filesrv1.baby-dragons.com>	 <1266100773.23181.8.camel@thorin>	 <524f69651002151133v475ebd02r80837adfc428fbfd@mail.gmail.com> <1266311771.3433.17.camel@thorin>
In-Reply-To: <1266311771.3433.17.camel@thorin>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Tue, 16 Feb 2010 07:13:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/16/2010 01:16 AM, Bernd Petrovitsch wrote:
> On Mon, 2010-02-15 at 13:33 -0600, Steve French wrote:
>> On Sat, Feb 13, 2010 at 4:39 PM, Bernd Petrovitsch
>> <bernd@petrovitsch.priv.at> wrote:
> [...]
>>>>       ntfs as of recent windows is not case insensitive .
>>> It *is* case insensitive (as it compares filesystem names
>>> case-insensitive on the equivalent of an open() syscall).
>>
>> There are case sensitive Windows subsystems (e.g. SFU/SUA
>> at least when running over NTFS), and the default behavior for
> 
>> Win32 apps even can be changed to be case sensitive
>> via a registry key: ObCaseInsensitive).
> It's somewhat - ähemm - strange IMHO that the casing is an app-specific
> feature (and not filesystem specific).
> And it is really that implemented that the app can choose in what way
> the filesystem below - given that it supports that feature - compares
> two filenames?
> 
>> More important is how easy it is to install - since XZ is
>> not even available via apt-get install on recent
>> distros (e.g. April 2009 Ubuntu 9.04), this discussion
>> seems about a year premature.
> It's in recent Fedoras so Ubuntu is perhaps just late. And FWIW, it' 2
> packages too as the second one is the .lzma support (so probably Debian
> should be able to fix the clash with whatever the current lzma package
> is).
> 
> 	Bernd

There's a package on Fedora called 'xz' that provides it on my Fedora 11
& 12 boxes.

- John 'Warthog9' Hawley
