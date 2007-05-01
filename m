Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXEAGus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXEAGus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 02:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXEAGus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 02:50:48 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:9146 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbXEAGur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 02:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mFiMCiohasmUkt99RZMnS/LtGpiTHqqisI1tQuqtJU6m0q3xQz4Egd6haHx3KUs4sGbZm3aNzsCRVq1Mu1nnkO9mV8Yds5cBvE6ms4d/tUmeCB/zXsWOVZTnjqcmj+LWPeX40u74dCMCN4QlT0rPs5z5n7wQzwjiA/t3L56yk44=
Message-ID: <62eb359a0704302350m5e639c17t8517865c885c9ba9@mail.gmail.com>
Date: Tue, 1 May 2007 01:50:47 -0500
From: "Marcos Pinto" <markybob@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: VMware, x86_64 and 2.6.21.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having the same problem.  I think it has to do with timer problems...
Does /sbin/hwclock --show freeze your box?  It "sometimes" works on
mine, but it  more often than not locks it hard (especially as user,
not root) with no hints in syslog or anywhere else as to what
happened.  This is a turion x2 with nvidia mcp51

On 5/1/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> Hi.
>
> Does anyone have VMware working on x86_64 with 2.6.21? It's working fine
> for me with 2.6.20, but freezes the whole computer with 2.6.21. Before I
