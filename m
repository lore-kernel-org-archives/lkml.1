Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZAFStu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZAFStu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZAFStf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:49:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36740 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZAFSte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:49:34 -0500
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: MCE error log
From: Andi Kleen <andi@firstfloor.org>
References: <c4e36d110901060500w289708d5ne252ace7a2fd9944@mail.gmail.com>
Date: Tue, 06 Jan 2009 19:49:37 +0100
In-Reply-To: <c4e36d110901060500w289708d5ne252ace7a2fd9944@mail.gmail.com> (Zdenek Kabelac's message of "Tue, 6 Jan 2009 14:00:03 +0100")
Message-ID: <87bpuk46da.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Zdenek Kabelac" <zdenek.kabelac@gmail.com> writes:

> /sys/devices/system/machinecheck/machinecheck1
> I could only see  bank0ctl ... bank5ctl - so where is bank 128 ?

Update your mcelog. Newer versions decode it.

-Andi

-- 
ak@linux.intel.com
