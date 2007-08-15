Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXHOJKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXHOJKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764546AbXHOJKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:10:05 -0400
Received: from baros.cubic.ch ([213.239.213.98]:42693 "EHLO baros.cubic.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763708AbXHOJKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:10:01 -0400
X-Greylist: delayed 4854 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 05:10:01 EDT
Message-ID: <46C2AFEC.1000309@cubic.ch>
Date: Wed, 15 Aug 2007 09:49:00 +0200
From: Tim Tassonis <timtas@cubic.ch>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Thinking outside the box on file systems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The ACLs that were added to Linux were a step in the
> right direction but very incomplete. What should be is
> a complex permission system that would allow fine
> grained permissions and inherentance masks to control
> what permission are granted when someone moves new
> files into a directory. Instead of just root and users
> there would be mid level roles where users and objects
> had management authority over parts of the system and
> the roles can be defined in a very flexible way. For
> example, rights might change during "business hours".

The problem with complex permission systems is, well, they are complex...

I'd still go for the UNIX KISS philosophy and the rather easy permission 
system, as it is easier to manage. Windows has all that great permission 
stuff, but if you look at the reality, hardly anybody uses it due to its 
complexity.

Tim


