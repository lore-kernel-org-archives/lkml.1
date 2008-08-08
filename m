Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYHHQeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYHHQeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYHHQeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:34:07 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:53309 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbYHHQeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:34:06 -0400
Date: Fri, 8 Aug 2008 12:32:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: worth separating serial from parallel ATA kernel options?
Message-ID: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  asked from a position of appalling ignorance, but would it be more
organized to be able to select serial ATA functionality separately
from parallel ATA?  i ask only because the current (lengthy) menu
seems to randomly mix them together and, more significantly, serial
ATA is categorized as production level, while parallel ATA is still
tagged as experimental.  just wondering ...

rday

p.s.  it's also amusing to see that things in that menu graduate from
"EXPERIMENTAL" to "Very Experimental" to "HIGHLY EXPERIMENTAL".  i'm
scared to see where this goes next.  :-)

--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
