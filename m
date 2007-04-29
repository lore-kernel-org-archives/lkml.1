Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbXD2Ay2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbXD2Ay2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXD2Ay2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:54:28 -0400
Received: from ns1.suse.de ([195.135.220.2]:56693 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbXD2Ay0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:54:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] i386: init early_gdt_descr and idle task properly on voyager
Date: Sun, 29 Apr 2007 02:52:56 +0200
User-Agent: KMail/1.9.6
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4633E507.7070002@goop.org>
In-Reply-To: <4633E507.7070002@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704290252.56280.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2007 02:21:27 Jeremy Fitzhardinge wrote:
> Initialize early_gdt_descr and idle task properly.
> 
> [ Incremental fix for "i386: introduce voyager smp_ops, fix voyager build" ]

Please do a merged patch again and I'm waiting for it being tested.

-Andi
