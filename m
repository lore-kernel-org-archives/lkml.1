Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbYDKPjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbYDKPjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbYDKPjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:39:07 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:6612 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYDKPjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PqbYl4gYqtV2jlO5SRIc6w/+1pMZQHpurc+SsxQ9SFbjaR+yFhW8VoyDRNUIoME/jbj3npGGIqc2aT7uw5AorI9k69LhCk/FxlyKW18TQ/MuL1ytdbyIqktxETyb/k0XwtgjXhDubyfGvQfaJjrn8zIyXoH6tSHdJOsld9bkyRI=
Message-ID: <b317600c0804110838p10d470dw841504bea3406007@mail.gmail.com>
Date: Fri, 11 Apr 2008 10:38:36 -0500
From: "Fred Trotter" <fred.trotter@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Introducing Fredux: a redundant project
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
         This message is not actually about a new project. It is also
not about the Linux Kernel specifically. Rather, I have a question
about how your community operates. If you feel this is off-topic,
please feel free to ignore it entirely. If you feel that this is
off-topic but interesting (my hope) then feel free to email me
directly at fred.trotter@gmail.com rather than gum up the mailing list
with a 'community' discussion. While this is marginally off-topic,
note that it is a discussion of principles that have been cited
frequently on this list, in the context of what is, and is not,
appropriate behavior:

http://groups.google.com/group/fa.linux.kernel/msg/dde6a60d7c57b8ee
http://groups.google.com/group/fa.linux.kernel/msg/706c1ced8dd711a7

         I work in the very, very small FOSS community focused on
making healthcare applications. Recently, we had a completely
redundant project start, and begin competing for attention and
resources. I called the project manager and chided him for dividing
our community resources. He had not even heard of the mature
alternatives to his project, yet he refused to consider that his
project and marketing was harmful to our larger community. This is
much more important for us than it is for kernel hackers, because our
entire community, covering all the health IT projects, is smaller than
the kernel community. Dividing the community is a critical problem for
us.
         Eric Raymond has written extensively on the violence that
unwelcome forks do to the community.

http://catb.org/~esr/writings/cathedral-bazaar/homesteading/ar01s03.html

         However, there is not much yet written about how new projects
can have a similar detrimental effect. Most of the people I have
talked to about this in my own community agree with me on this,
however when I publicly chide this new project manager in more
generally Healthcare IT communities I come off looking like a bully. I
think this because there is no "written rule" about this issue, so it
seems like I am arbitrarily attacking this new project.
         So I wrote a short article outlining my position. It is available here:

http://www.fredtrotter.com/2007/11/27/foss-sin-pointless-duplication-of-effort/

        Central to the article is a discussion of a hypothetical
project started by me, in competition to the Linux Kernel, called
Fredux. Fredux is intended to represent everything bad about starting
a new redundant project. Then I compare the hypothetical Fredux to
Linux, OpenBSD and Hurd. Linux being the "dominate" project while Hurd
and OpenBSD represent projects that justify their existence in the
context of a solid dominate project.

        So much of my argument is based on using the Linux community
as the center of an example, that I thought I should take a moment and
ask you what you thought of my thesis? What makes a new project
legitimate versus an also-ran? Later I will ask other communities this
same question but I wanted to start with the community I use in my
examples. Here is my current list of what might make a new project
legitimate:

    * The project uses a different programming language, which has
some advantage in the field of inquiry.
    * The project addresses a serious feature gap in current projects.
    * The project addresses a serious design limitation in current projects.
    * The project uses a new programming paradigm that has advantages
over those currently in use.
    * The project uses a different development process that might have
some advantages.
    * The project uses a more common and accepted FOSS license than
alternative projects.

Recognizing that your community, given its strength and size, probably
does not care much about competition, I wanted to get a feel of what
the "rules" might look like in your opinion. Feel free to contact me
off-line or post responses to the article directly rather than
replying here.

Regards,

-- 
Fred Trotter
http://www.fredtrotter.com
