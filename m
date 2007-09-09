Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbXIIMaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbXIIMaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 08:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbXIIM34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 08:29:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:47555 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbXIIM3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 08:29:55 -0400
Message-ID: <46E3E73D.1060404@qumranet.com>
Date: Sun, 09 Sep 2007 15:29:49 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/3] KVM paravirtualization framework (v2)
References: <1188243723984-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <1188243723984-git-send-email-aliguori@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> This patchset refactors KVM's paravirtualization support to better support
> guest SMP and cross platform migration.  It also introduces a bare-bones KVM
> paravirt_ops implementation.
>
> I've tested this on VT and it works nicely.  I'm having trouble getting a
> bzImage to boot on SVM so I haven't been able to test on SVM yet.
>
> I've incorporated all of the feedback into this series from posting the
> last series.
>   

Can you send this patchset out again?  There were some updated patches 
posted and I'm not sure I can find the most recent ones.


-- 
error compiling committee.c: too many arguments to function

