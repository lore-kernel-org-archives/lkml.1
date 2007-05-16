Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbXEPXcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbXEPXcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbXEPXcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:32:12 -0400
Received: from serverina.hacknight.org ([80.68.90.101]:1509 "EHLO
	serverina.hacknight.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbXEPXcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:32:11 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.21-rt2
References: <20070516180447.GA17922@elte.hu>
From: Free Ekanayaka <free@64studio.com>
Organization: 64 Studio
Date: Thu, 17 May 2007 01:32:02 +0200
In-Reply-To: <20070516180447.GA17922@elte.hu> (Ingo Molnar's message of "Wed, 16 May 2007 20:04:47 +0200")
Message-ID: <87fy5wny4t.fsf@64studio.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

|--==> Ingo Molnar writes:

  IM> i'm pleased to announce the v2.6.20-rt2 kernel, which can be downloaded 
  IM> from the usual place:

  IM>     http://redhat.com/~mingo/realtime-preempt/

This new version of the patch solves the amd64/udev bug I reported
against previous releases:

http://www.mail-archive.com/linux-rt-users@vger.kernel.org/msg00353.html

I'm going to test the patch on other amd64 machines as well, thanks a
lot and keep up goo the work!

Ciao,

Free
