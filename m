Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbZLQGLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbZLQGLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 01:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758976AbZLQGLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 01:11:19 -0500
Received: from Mail.MNSU.EDU ([134.29.1.12]:58912 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758820AbZLQGLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 01:11:18 -0500
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 01:11:18 EST
Message-ID: <4B29C5FA.8090909@mnsu.edu>
Date: Wed, 16 Dec 2009 23:47:38 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Daniel Poelzleithner <poelzi@poelzi.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Suggestion: xtime as new inode attribute
References: <4B292D9A.5060501@poelzi.org>
In-Reply-To: <4B292D9A.5060501@poelzi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Poelzleithner wrote:
> The problem:
>
> If a linux installation gets older and older, more and more programs get
> installed over time. Mostly to just test them for a particular problem
> and often the deinstallation is forgotten. To find out which packages
> are not used for a long time is currently quite impossible. The user may
> use program X which will run but not depend on program Y as a subprocess
> for example.
>
> The solution:


Perhaps something like the "Debian package Popularity Contest":
http://popcon.debian.org/

...
The popularity contest project is an attempt to map the usage of Debian
packages. This site publishes the statistics gathered from report sent
by users of the popularity-contest  package. This package sends every
week the list of packages installed and the access time of relevant
files to the server via email. Every day the server anonymizes the
result and publishes this survey. For more information, read the README
and the FAQ.
...


-- 
Jeffrey Hundstad

