Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab0BQBgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 20:36:40 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:35396 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933816Ab0BQBgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 20:36:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DU3C+PfOyhNdigAIvOGDN5/KkL3EXy+/rqAloWwz+24AuRua3v7CnuLut5239aEtpx
         HRqmbhY5Gk7J8fhK39zQl9zDrmrP/SPJaiw2h04KNCqpj7tbqNDxBEjNTQE7phDrM0hN
         7MQUvQutqsDKboi8eAvsnNmgxswDg7o8/i3F4=
MIME-Version: 1.0
In-Reply-To: <4B7AB9C0.6070402@kernel.org>
References: <4B744E13.8040004@kernel.org> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> 
	<4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> 
	<20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare> 
	<20100214170724.GE1578@ucw.cz> <20100214200803.4b2348ce@hyperion.delvare> 
	<20100215151522.GI5337@thunk.org> <4B7AB9C0.6070402@kernel.org>
From: David Rees <drees76@gmail.com>
Date: Tue, 16 Feb 2010 17:36:17 -0800
Message-ID: <72dbd3151002161736vfa1925te61a5698eb882940@mail.gmail.com>
Subject: Re: [kernel.org users] XZ Migration discussion
To: "J.H." <warthog9@kernel.org>
Cc: tytso@mit.edu, Jean Delvare <khali@linux-fr.org>,
       Pavel Machek <pavel@ucw.cz>, mirrors@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 7:29 AM, J.H. <warthog9@kernel.org> wrote:
> On 02/15/2010 07:15 AM, tytso@mit.edu wrote:
>> People who think xz are good should be working to get it installed by
>> default into the community and then enterprise distro's, first....
>
> As a note xz is available via EPEL for Redhat Enterprice Linux 5 and
> anything that's derived from that.  Doesn't seem to be available,
> directly, for 4 or lower.  Not sure on Suse, and Debian's already been
> mentioned.  Just trying to do a quick survey of what's out there already.

Something I noticed, too.  Hopefully going to work on getting set up
as a packager and get xz pushed out to EPEL EL-4 over the next couple
weeks unless someone else beats me to it as I still have a handful of
EL-4 machines grinding away. :-)

-Dave
