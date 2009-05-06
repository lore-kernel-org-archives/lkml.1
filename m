Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbZEFByX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbZEFByX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 21:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZEFByI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 21:54:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34712 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZEFByH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 21:54:07 -0400
Message-ID: <4A00ED83.1030700@zytor.com>
Date: Tue, 05 May 2009 18:53:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, mingo@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH] x86: 46 bit PAE support
References: <20090505172856.6820db22@cuia.bos.redhat.com>
In-Reply-To: <20090505172856.6820db22@cuia.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Testing: booted it on an x86-64 system with 6GB RAM.  Did you really think
> I had access to a system with 64TB of RAM? :)

No, but it would be good if we could test it under Qemu or KVM with an
appropriately set up sparse memory map.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

