Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbYAHFur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbYAHFur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYAHFui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:50:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38311 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756513AbYAHFuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:50:37 -0500
Date: Mon, 7 Jan 2008 21:50:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kexec fail
In-Reply-To: <86802c440801071837q1d6d63ewf095c9b497b33785@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801072150050.28773@schroedinger.engr.sgi.com>
References: <86802c440801071837q1d6d63ewf095c9b497b33785@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Yinghai Lu wrote:

> try to kexec 2.6.23 from RHEL 5.1, will get
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM ======> reboot
> 
> but 2.6.24-rc7 kexec 2.6.24-rc7 is ok.

BUG in 2.6.23 kexec?

