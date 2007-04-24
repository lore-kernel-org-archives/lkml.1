Return-Path: <linux-kernel-owner+w=401wt.eu-S1423162AbXDXWSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423162AbXDXWSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423161AbXDXWSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:18:08 -0400
Received: from quechua.inka.de ([193.197.184.2]:50979 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423162AbXDXWSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:18:07 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20070424212717.GR31925@holomorphy.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HgTKk-0008IK-00@calista.eckenfels.net>
Date: Wed, 25 Apr 2007 00:18:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070424212717.GR31925@holomorphy.com> you wrote:
> Could you explain for the audience the technical definition of fairness
> and what sorts of error metrics are commonly used? There seems to be
> some disagreement, and you're neutral enough of an observer that your
> statement would help.

And while we are at it, why it is a good thing. I could understand that fair
means no missbehaving (intentionally or unintentionally) application can
harm the rest of the system. However a responsive desktop might not
necesarily be very fair to compute jobs.

Even a simple thing as "who gets accounted" can be quite different in
different workloads. (larger multi user systems tend to be fair based on the
user, on servers you more balance by thread or job and single user systems
should be as unfair as the user wants them as long as no process can "run
away")

Gruss
Bernd
