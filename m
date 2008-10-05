Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYJEG0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYJEG0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 02:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYJEG0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 02:26:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:52216 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbYJEG0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 02:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GTtVJE8J0EVIttRIvSiL61zS0ozARtcFNlbtJz4WHvtLELCqnga1+AzEYyb3xEJtbs
         1qne1YLmqkSL22LO3NTlHvduBHT9ZLbHrhx8qP8eFGJmeVhQqLSj7oxk+F7qgXhrq6Df
         /SREk/vNt1Vc4SJpsRYWWKMZziGsdquS8Mpws=
Message-ID: <4b6fba110810042326i140b967ay1873fc0fdd0a4347@mail.gmail.com>
Date: Sun, 5 Oct 2008 02:26:34 -0400
From: "Daniel Rosenthal" <danielrosenthal@acm.org>
To: roger.gammans@gmail.com, tytso@mit.edu
Subject: Re: copy of "The Extended 3 Filesystem" paper?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <5ef2a8660810031500j4c4bf8cas3e28292433897a3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4b6fba110810031427s5296511cx135616cff632790b@mail.gmail.com>
	 <5ef2a8660810031500j4c4bf8cas3e28292433897a3f@mail.gmail.com>
X-Google-Sender-Auth: 6242b1569293b0d1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 6:00 PM, Roger Gammans <roger.gammans@gmail.com> wrote:
>
> I've  got something which appears to be an HTML transcript of sct's
> presentation here.
>
> I'll send it to you if you want. Unless someone raises an objection.
>
> Roger
>

Is it different from:
http://olstrans.sourceforge.net/release/OLS2000-ext3/OLS2000-ext3.html

If so, sure, that would help.  If not, the transcript above actually
appears to contain answers to many of the questions I had.

I also found some documentation in the kernel Documentation/DocBook
directory from an email you sent in 2002 (
http://lkml.org/lkml/2002/3/22/97 ).  I did not see this the first
time around because there does not seem to be much info about DocBook
in Documentation/ other than the DocBook directory itself, and it
doesn't seem to be easy to stumble across on the web unless you know
to look for it.  I've compiled and posted the HTML DocBook on my
website:

http://ww2.cs.fsu.edu/~rosentha/linux/current/docs/DocBook/

I also posted the whole Documentation directory at
http://ww2.cs.fsu.edu/~rosentha/linux/current/docs/ .  I hope this
helps somebody else avoid a lot more grief than I did.  If somebody
can tell me what packages I need to compile the pdfdocs, I can post
those too.


On Fri, Oct 3, 2008 at 6:06 PM, Theodore Tso <tytso@mit.edu> wrote:
>
> I don't have a copy of that paper paper myself, but most of the
> information is probably contained in the 1998 Linux Expo paper, which
> is available here:
>
>   http://ext4.wiki.kernel.org/index.php/Publications
>
> If you come across other ext4 papers, please feel free to add it to
> the wiki.
>                                                - Ted
>

Thanks for the link.  Do you mind if I add a link to the transcript
linked to above, though not really a publication? (I'm talking about
http://olstrans.sourceforge.net/release/OLS2000-ext3/OLS2000-ext3.html
)


Thanks for the help,
Daniel
