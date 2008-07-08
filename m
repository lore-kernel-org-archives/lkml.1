Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbYGHHZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbYGHHZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYGHHZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:25:28 -0400
Received: from main.gmane.org ([80.91.229.2]:59027 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYGHHZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:25:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Keeping track of spin-down/spin-up and causes of spin-up?
Date: Tue, 08 Jul 2008 03:25:18 -0400
Message-ID: <jwvskuku9jr.fsf-monnier+gmane.linux.kernel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 206-248-135-194.dsl.teksavvy.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
Cancel-Lock: sha1:6impTIGCFt5QCe3IKKTj7ujvpc8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I clearly remember seeing a reference to some system that allowed to
keep track of causes of disk spin-up, but Google seems to say
I'm deluded.  [ Or maybe my memory confused it for the facility used by
powertop to keep track of causes of CPU wake-ups? ]

In any case, I have a machine here whose disk keeps spinning back up
on a regular basis, and I can't seem to find any correlated event.
Is there a tool that can help me track down the reason why the disk
is accessed?


        Stefan

