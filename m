Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbXIBRqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbXIBRqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbXIBRqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:46:47 -0400
Received: from ms-smtp-06.texas.rr.com ([24.93.47.45]:33786 "EHLO
	ms-smtp-06.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbXIBRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:46:47 -0400
Message-ID: <46DAF70E.9060800@austin.rr.com>
Date: Sun, 02 Sep 2007 12:46:54 -0500
From: "Jonathan A. George" <jageorge@austin.rr.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: "GPL weasels and the atheros stink"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While the title of Marc's email might be construed as flame bait, it is 
disappointing to see that the generally very valid points he has made 
(as both a BSD _and_ _GPL_ developer) are being ignored. To make it 
simple try answering these two questions:

----
Question #1: Is it _ethical_ (legality aside) to take someone else's 
actively maintained work (for example an OpenBSD driver) and make 
changes which can not be shared/used by the original developer/maintainer?

Answer #1: Considering that the whole reason I personally choose the GPL 
for some projects is to prevent this sort of one way street behavior 
_away_ from the original OSS developers/contributors _my_ answer must 
be; No it is not ethical.

----
Question #2: Is it _technically beneficial_ to branch an OSS work (for 
example an OpenBSD driver) in such a way as to diminish the ability to 
share contributions between projects?

Answer #2: It would be fascinating (and sad) to see an attempt at 
justifying a yes response to this question.


Please don't let the rude language or defensiveness bought out by this 
particular incident distract from doing the right thing.  Just because 
you legally can (or might be able to) do something doesn't make it right.


--Jonathan--


P.S. As a secondary concern; it could be legally dubious with some 
governments to relicense an existing file from the OpenBSD license 
(given that the copyright license must remain intact) -- though patches 
could themselves _technically_ be GPL.  Creating _new_ GPL files which 
work _with_ the existing BSD licensed has no such ambiguity, but please 
see questions #1 and #2 above -- is it the _right_ thing to do?
