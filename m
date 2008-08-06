Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbYHFCdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbYHFCdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 22:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763043AbYHFCdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 22:33:17 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:60996 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762557AbYHFCdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 22:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rmj7NjK5xYX7Juvs1iCx1CPna3z+tskeXFi0JUCIAgPZmzP5vIgNUtN+TWZ5r+zza7
         1FaPt0U8gzWB6asZaZSJFzkjlRmiJL2yoZ1c++B5fZNqjBu8EWEkuoP+bvgiUBk9dQM2
         O/hUfoQN+YFXX2C6bLMoFhhv0xQ2YlSiL80RE=
Message-ID: <df9815e70808051933l32798d4y913e16872c256a88@mail.gmail.com>
Date: Wed, 6 Aug 2008 10:33:13 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "David Wilson" <mcs6502@gmail.com>
Subject: Re: What is the best way to identify a new x86 processor that does not implement the CPUID instruction?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3666888f0808050008h38e11737k8e6cb9c4c85aa457@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3666888f0808050008h38e11737k8e6cb9c4c85aa457@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 3:08 PM, David Wilson <mcs6502@gmail.com> wrote:
> I have thought of a couple of schemes but am not really keen on either:
>
> 1) Clock speed - the SoC runs at 300+ MHz while the Cyrix part is < 100 MHz
at which speed this Soc is running when being recognized as Cyrix part by Linux?

> 2) Look at the PCI VID/PID for the north bridge as this is part of the CPU die.
>

As you said, since the manufacturer has provided some codes to tune
the CPU speed, did they provide any method to identify the CPU without
a cpuid function?
