Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbXLKBUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbXLKBUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 20:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXLKBUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 20:20:05 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60892 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbXLKBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 20:20:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Neil Horman <nhorman@redhat.com>, Ben Woodard <woodard@redhat.com>,
       kexec@lists.infradead.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <474F7177.7050306@redhat.com> <20071130144250.GC23810@redhat.com>
	<20071130145131.GB5822@hmsendeavour.rdu.redhat.com>
	<20071206213951.GB28898@hmsreliant.think-freely.org>
	<20071206221143.GC2863@redhat.com>
	<m1bq93s5r8.fsf@ebiederm.dsl.xmission.com>
	<86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com>
	<86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com>
	<20071207142144.GA10389@hmsendeavour.rdu.redhat.com>
	<20071207175832.GA18485@hmsreliant.think-freely.org>
	<20071210153959.GA23290@hmsreliant.think-freely.org>
Date: Mon, 10 Dec 2007 18:17:06 -0700
In-Reply-To: <20071210153959.GA23290@hmsreliant.think-freely.org> (Neil
	Horman's message of "Mon, 10 Dec 2007 10:39:59 -0500")
Message-ID: <m17ijm2fot.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry to reply to myself, but do we have consensus on this patch?  I'd like to
> figure out its disposition if possible.  

What the patch tries to do looks like the right thing.  So if we can get
a version that is clean and actually works we should merge it.

Eric
