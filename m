Return-Path: <linux-kernel-owner+w=401wt.eu-S933550AbXGVMwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbXGVMwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933400AbXGVMwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:52:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:34711 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933032AbXGVMwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:52:31 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/3] x86_64: store core id bits in cpuinfo_x86
Date: Sun, 22 Jul 2007 14:43:26 +0200
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <86802c440707211749g7a45623aka16f6e647f8da885@mail.gmail.com>
In-Reply-To: <86802c440707211749g7a45623aka16f6e647f8da885@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707221443.27061.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 02:49:26 Yinghai Lu wrote:
> [PATCH 1/3] x86_64: store core id bits in cpuinfo_x86
> 
> We need to store core id bits to cpuinfo_x86 in early_identify_cpu. So we
> use it to create acpiid_to_node array in k8topolgy.c

Looks good

-Andi
