Return-Path: <linux-kernel-owner+w=401wt.eu-S934604AbZAOVGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934604AbZAOVGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762251AbZAOUqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:46:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:33296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933521AbZAOUqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:46:30 -0500
Message-ID: <496FA083.3050304@kernel.org>
Date: Thu, 15 Jan 2009 12:45:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Kirin <james.kirin40@gmail.com>
CC: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: memory beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y
References: <baeb34bc0901131746n33cd536co331e32361df2fb72@mail.gmail.com>	 <adaeiz6k4o4.fsf@cisco.com>	 <baeb34bc0901131910n55cae670qc9d02c9f78c6432@mail.gmail.com>	 <86802c440901132207l433227d9nf149506012a5721e@mail.gmail.com>	 <baeb34bc0901151150w4ad88du78d91f6db50983e1@mail.gmail.com> <baeb34bc0901151235v3c19306enaa2b6b11a18e1275@mail.gmail.com>
In-Reply-To: <baeb34bc0901151235v3c19306enaa2b6b11a18e1275@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Kirin wrote:
> I tried disabing CONFIG_MTRR_SANITIZER and CONFIG_X86_PAT in the
> kernel, and now a different kernel panic occurs:
> 
> [... ] Write protecting the kernel text: 3040k
> [...] Write protecting the kernel read-only data: 1352k
> [... ] khelper used greatest stack depth: 6724 bytes left
> [ ...] Kernel panic - not syncing: No init found. Try passing init=
> option to kernel.
> 
> Is an "init=" option necessary when using disable_mtrr_trim?

that is not related...

YH
