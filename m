Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYCVUwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYCVUwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 16:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYCVUwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 16:52:17 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:47906 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbYCVUwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 16:52:16 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Mar 2008 16:52:16 EDT
Date: Sat, 22 Mar 2008 16:44:04 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Justin Mattock <justinmattock@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: fglrx
In-Reply-To: <dd18b0c30803210925x755f3f07o1e2bb0cd60c9ce7e@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0803221641570.24807@mtl.rackplans.net>
References: <dd18b0c30803210925x755f3f07o1e2bb0cd60c9ce7e@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Justin Mattock wrote:

> Hello; fair enough, I did ask ati about what I should do, but there
> wasn't much help. Overall its not pretty, but If you are impatient for
> ati to come out with an update then this should get you going(for 3D).
> The problem I see is, SELinux is going out of whack due to fglrx
> wanting a cap_t effective vector.  So on the secure side I probably
> wont use fglrx until there is support for the proper capability.
> or take you're approach and look at the open ati driver.
> 

The only fix is to get rid of the ATI video card.  I've had this problem 
in the past with their stuff and just ended up beating my head against a 
wall.  It's not worth it .. trust me.  The fglrx driver has been crap for 
over two years and the open sourced versions are slow leaving me to give 
up and just buy something else.


Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
