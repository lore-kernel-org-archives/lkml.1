Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbXK1Sp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbXK1Sp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbXK1SpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:45:14 -0500
Received: from main.gmane.org ([80.91.229.2]:48355 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbXK1SpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:45:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jakub Narebski <jnareb@gmail.com>
Subject: Re: git guidance
Followup-To: gmane.comp.version-control.git,gmane.linux.kernel
Date: Wed, 28 Nov 2007 19:41:01 +0100
Organization: At home
Message-ID: <fikcns$mte$1@ger.gmane.org>
References: <20071127235237.GF15227@1wt.eu> <200711282014.27299.a1426z@gawab.com> <Pine.LNX.4.64.0711281811500.27959@racer.site> <200711282130.12864.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: abvr156.neoplus.adsl.tpnet.pl
Mail-Copies-To: Jakub Narebski <jnareb@gmail.com>
User-Agent: KNode/0.10.2
Cc: git@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Johannes Schindelin wrote:

>> By that definition, no SCM, not even CVS, is transparent.  Nothing short
>> of unpacked directories of all versions (wasting a lot of disk space)
>> would.
> 
> Who said anything about unpacking?
> 
> I'm talking about GIT transparently serving a Virtual Version Control dir to 
> be mounted on the client.

Are you talking about something like (in alpha IIRC) gitfs?

  http://www.sfgoth.com/~mitch/linux/gitfs/


Besides, you can always use "git show <revision>:<file>". For example
gitweb (and I think other web interfaces) can show any version of a file
or a directory, accessing only repository.

-- 
Jakub Narebski
Warsaw, Poland
ShadeHawk on #git


