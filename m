Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJaV4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJaV4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYJaVz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:55:56 -0400
Received: from node02.cambriumhosting.nl ([217.19.16.163]:34838 "EHLO
	node02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYJaVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:55:55 -0400
Message-ID: <490B7EE5.5030701@powercraft.nl>
Date: Fri, 31 Oct 2008 22:55:49 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080724 Thunderbird/2.0.0.16 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: em28xx@mcentral.de, linux-dvb@linuxtv.org, greg@kroah.com, akpm@osdl.org,
       mchehab@infradead.org
Subject: em28xx merge process issues with linuxtv and upstream kernel
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello everybody,

I would like to discuss some issues with the em28xx-new project and the
re-merging process with the upstream code and the linuxtv project.

First I would like to say that I am not an active developer on this
project, but a very heavy user that followed the project very close and
made some documentation, packages, helped getting some issues discussed
and some devices added. This project is important for me because I need
it to be merged successfully and with width support so it will become
maintainable on large basis.

This is the situation:

Markus Rechberger has worked for more than 3 years on a clone/fork of
the official code, creating the em28xx-new [1] project. He has worked
very very hard on this project and produced a lot of code and provides a
lot of support to the users of his project. It takes lot of energy and
resources to pull of this kind of work! I do really respect this work
and hope others also do this!

In a good free software development process somebody would clone some
work to his own personal repository, then add or fix one feature. Create
a diff compared with the upstream code and then. Commit the patch with
good description to the upstream project, so this feature and its code
changes can be reviewed, tested and supported. After this one feature
fix and patch, a developer moves to his next feature and repeats to
process so step by step and patch by patch the project grows. This
understanding of the code bye a larger group of people will lead to a
platform of developers that can maintain and contribute to the project.
This would be the proper way of doing things it most cases, but a
developer need to know and understand or mentored with this from the start.

However sometimes a developer works very hard on the code creating lots
of new features, adding support for lots of new devices and fixes lots
of issues without committing patches during the process. After 3 years
or more its understandable that it can lead to a code base almost
unrecognizable from the initial cloned code base. So what to do now! To
ask from the developer to completely separate all his work in individual
patches that can be committed to upstream is almost unrealistic. A good
plan needs to be created and discussed by the people that matter.

In this case I have seen several attempts of Markus to make large
patches and some smaller to try getting his code merged upstream, but
they were after short discussion rejected, because they did not fit the
one patch for one fix, feature, etcetera standard/idea.

I am going to ask for understanding of both the side of Markus that
worked very hard on his code, and that of the upstream developers. There
are both valid reasons on how they did there things.

But we need a solution to get all the code back into the upstream
project so it can go into the kernel project and eventually be delivered
at the Linux distributions and all there users, so no custom compiling,
custom package install are required and non transparent bug reports can
be stopped.

Is it possible for an upstream developer to step forward and take on the
task of merging the code of Markus back into mainstream, all questions
on the code can be discuses on several mailing-list [2] of choice.

Current the situation is kind of a hold-of, the issues are not being
discussed, the problem is not addressed, so no process is made and
during this time users are suffering from non working nor good supported
devices for there hybrid dvb-t/analog broadcast experiences under Linux.

I hope this lead to a productive discussion that will get the code to
the end users through there main distribution systems.

Kind regards,

Jelle de Jong

[1] http://mcentral.de/
[2] http://mcentral.de/mailman/listinfo/em28xx
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iJwEAQECAAYFAkkLfuMACgkQ1WclBW9j5HnpUwP9HgYDHBeAxAtCMjH2Ffzil0En
7g9WT9KXG+ZFP+pToDuFaIcj6uJVzivhrShzoCt9kqjjFGVnFZHz4MgG0U8k1nuh
e/9ZFm9n1RN9zmsbbRB3agQKuCheqwrUJyJm3Pc9kcE8myC8SLv6drgHcaUTumzm
2gdHeB4HDNtM2ADbq/g=
=zQzU
-----END PGP SIGNATURE-----
