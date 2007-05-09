Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbXEIIR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbXEIIR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXEIIRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:17:44 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:60986 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXEIIRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:17:43 -0400
Message-ID: <4641836C.200@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 10:16:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle: start flamewar about use of braces
References: <200705081903.l48J3AOw010373@hera.kernel.org>	 <20070508124301.17975a4f.randy.dunlap@oracle.com>	 <4640E971.9050400@garzik.org> <a781481a0705081637x129cb009u6a557205d3776014@mail.gmail.com>
In-Reply-To: <a781481a0705081637x129cb009u6a557205d3776014@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> It's quite funny to worship them as "prophets" and adopt their style
> for some stuff (with a simple "Rationale: K&R.") one instant and then
> suggest a style completely opposite to theirs one screenful later in
> the same file.

That's what happens to a text which is incrementally written by people
with different writing styles (and different opinions).

As a slightly off-topic side note:  CodingStyle was once a guideline
which sort of worked because it was a compact and entertaining read; so
some people took the time to read it and didn't mind too much to adopt
the preferred style.  It appears that CodingStyle is now being
transformed into a norm which the authors want to make work by being
comprehensive, and by being able to point offenders to a chapter/
section/ clause which they breached.  Alas only a few people will be
able and willing to memorize CodingStyle's rules then.

I don't know which form is better suited to the goal of well
maintainable code --- the compact, easy to read, winning guideline, or
the comprehensive norm.
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/
