Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZJGWVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZJGWVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZJGWVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:21:24 -0400
Received: from lo.gmane.org ([80.91.229.12]:35406 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbZJGWVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:21:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jack Byer <ojbyer@usa.net>
Subject: iso9660 mount problem
Followup-To: gmane.linux.kernel
Date: Wed, 07 Oct 2009 17:22:02 -0500
Message-ID: <haj471$fn8$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp-70-242-115-61.dsl.rcsntx.swbell.net
User-Agent: KNode/4.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a CD of a commercial software program that I am attempting to run 
under wine. The CD works without problems under Windows, but when I mount  
it on linux the file system appears to be empty (no files or 
directories). The drive is capable of reading the CD because "strings 
/dev/cdrom" works.

What would I need to do in order to troubleshoot this problem?



