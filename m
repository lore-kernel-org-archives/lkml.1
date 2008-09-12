Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYILVLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYILVLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYILVLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:11:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52992 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbYILVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:11:29 -0400
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
From: Andi Kleen <andi@firstfloor.org>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>
	<20080912122031.eca8723e.akpm@linux-foundation.org>
	<86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com>
Date: Fri, 12 Sep 2008 23:11:26 +0200
In-Reply-To: <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> (Yinghai Lu's message of "Fri, 12 Sep 2008 12:29:41 -0700")
Message-ID: <878wtxrrwh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
> to see how wrong could be set by BIOS.

Just dump it from user space then.  There are plenty of tools
to access ACPI tables.

-Andi

-- 
ak@linux.intel.com
