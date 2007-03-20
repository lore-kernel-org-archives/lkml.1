Return-Path: <linux-kernel-owner+w=401wt.eu-S934022AbXCTQ3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022AbXCTQ3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934032AbXCTQ3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:29:43 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:59254 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934022AbXCTQ3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:29:42 -0400
Date: Tue, 20 Mar 2007 17:23:48 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Oliver Falk <oliver@linux-kernel.at>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: axp question 'bout uname voodoo
In-Reply-To: <45FF9885.4090006@linux-kernel.at>
Message-ID: <Pine.LNX.4.61.0703201722410.20032@yvahk01.tjqt.qr>
References: <45FE80FD.9090109@linux-kernel.at> <m1ejnlxh4j.fsf@ebiederm.dsl.xmission.com>
 <45FF9885.4090006@linux-kernel.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 20 2007 09:17, Oliver Falk wrote:
>
> But on i386 it reports:
> [oliver@pils ~]$ uname -mpi
> i686 i686 i386

Reports this for me:
$ uname -mpi
i686 athlon i386

> And I remember that it used to report alphaev67 or alphaev56...

Jan
-- 
