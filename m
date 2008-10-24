Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYJXPdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYJXPdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYJXPdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:33:42 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:52875 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYJXPdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:33:42 -0400
Message-ID: <4901EAD0.4000500@diamondcut.com.br>
Date: Fri, 24 Oct 2008 13:33:36 -0200
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: debian-user-portuguese@lists.debian.org
Subject: [2.6.26] Impossible to be loaded (call trace in line)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Can someone, pls, check this call trace below?
<http://ultramanworld.com.br/fabio/23102008112.jpg>
<http://ultramanworld.com.br/fabio/23102008113.jpg>
<http://ultramanworld.com.br/fabio/23102008114.jpg>
<http://ultramanworld.com.br/fabio/23102008115.jpg>

This problem is happening in a low-cost laptop (CCE NXK-93C) running
Debian Lenny (Kernel 2.6.26) in boot time, and is impossible system
start-up.

All this options was already tested:
noacpi noapic nolapic idle=poll ide=nodma apm=off acpi=off noresume
selinux=0 nosmp maxcpus=0 edd=off

Best regards,
Renato
