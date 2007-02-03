Return-Path: <linux-kernel-owner+w=401wt.eu-S933402AbXBCAkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbXBCAkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933407AbXBCAkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:40:37 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59640 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933402AbXBCAkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:40:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Luigi Genoni" <luigi.genoni@pirelli.com>
Cc: <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: System crash after "No irq handler for vector" linux 2.6.19
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
Date: Fri, 02 Feb 2007 17:40:02 -0700
In-Reply-To: <200702021905.39922.luigi.genoni@pirelli.com> (Luigi Genoni's
	message of "Fri, 2 Feb 2007 19:05:39 +0100")
Message-ID: <m1r6t83wgt.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Luigi,

Unless you have a completely different cause I believe the patches I
just posted will fix the issue.  If you can test and confirm this that
would be great.

Eric
