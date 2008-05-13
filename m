Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbYEMPJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbYEMPJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbYEMPJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:09:15 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:58083 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbYEMPJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:09:14 -0400
Message-ID: <4829AF7B.6040601@keyaccess.nl>
Date: Tue, 13 May 2008 17:10:51 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters
References: <4388.1210613272@vena.lwn.net>
In-Reply-To: <4388.1210613272@vena.lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-08 19:27, Jonathan Corbet wrote:

> So here's what we would like to try instead.  Whenever somebody sends up a
> patch fixing a reported bug, the name of the person who reported the bug
> would be immortalized with this tag:
> 
> 	Reported-by: A. Bug Reporter <email@goes.here>
> 
> In particular, reporters who work with the developers toward the resolution
> of the bug should be thanked in this way.  If we wanted to take things
> further, perhaps we could add a Bisected-by: tag for really hard-core
> helpers.

Ingo Molnar recently already used the latter:

http://marc.info/?l=linux-kernel&m=121032355203154&w=4

and a reply of mine consisted of now also needing a Reported-By:

http://marc.info/?l=linux-kernel&m=121037403515110&w=4

I must say the Bisected-by thing did feel a bit childish ("ah, I'm not 
in it to get the bug fixed but to get my name mentioned!") but hey, I 
find things to be offended over easily. From the example it does seem 
you probably want both if you have one; if reporter, nailer-downer and 
fixer are three seperate people.

Rene.
