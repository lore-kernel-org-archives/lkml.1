Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbXIERGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbXIERGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXIERFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:05:54 -0400
Received: from smtp01.cdmon.com ([212.36.74.230]:50522 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbXIERFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:05:53 -0400
Date: Wed, 5 Sep 2007 19:05:10 +0200
From: DervishD <lkml@dervishd.net>
To: Sean Robert McGuffee <sean.mcguffee@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AUTO LOGIN BUG
Message-ID: <20070905170510.GA2032@DervishD>
Mail-Followup-To: Sean Robert McGuffee <sean.mcguffee@gmail.com>,
	linux-kernel@vger.kernel.org
References: <46DE8965.6070600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46DE8965.6070600@gmail.com>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Dear whoever,

 * Sean Robert McGuffee <sean.mcguffee@gmail.com> dixit:
> Dear whoever is in charge of writing fedora core 7,

    Have you tried FC forums? This list is about the linux kernel, not
about distros. The name, "Linux Kernel Mailing List" should have rang a
bell (or even two).
 
> The auto login is a wonderful feature. However, there is a HUGE flaw
> in it at the moment. It won't let me log in a root that way. That is
> MY decision, not YOUR decision. Please fix it in an update!!! I'm sick
> of having to log in as root every single time I use my computer.

    I don't know why are you login as root frequently (so as to annoy
you having to type a password), but since you're not... wise enough to
know that this list is about the kernel and not a distro, I recommend
you AGAINST login as root.

    Moreover, since you don't know how to disable root password, I don't
think is wise you log in as root AT ALL.

    This said, if you want to avoid having a password for root (probably
a cracker someday will thank you for that), go and edit /etc/passwd (or,
if you prefer security through obscurity, which may well be the case)
/etc/shadow, and leave the password field for root empty. It's the
second field, after the first colon.

> I understand that there are situation where people have other people
> use their computer and don't want them to be root. However, I never
> want to be logged in as anything other than root, and I suspect
> everyone who has half a brain is the exact same way.

    Oh, so you're just a troll. Well, in fact half a brain is needed to
log always as root, so I won't discuss that. And given that I took the
time to write the instructions so you can hang yourself, I'll send this
message even if it is obvious you're a troll.

    Happy trolling, and if someone suggests you to get a life, don't
listen, trolling is much funnier! As you may already experienced,
getting a life can be very hard, but trolling is easy.

    And to the list, sorry for feeding the troll, but it looked furry
and adorable O:)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
We are waiting for 13 Feb 2009 23:31:30 +0000 ...
