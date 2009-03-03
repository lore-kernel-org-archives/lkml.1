Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZCCFnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZCCFnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 00:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbZCCFn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 00:43:29 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:19132 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZCCFn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 00:43:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wtB0tnVjDfUsznuymc7uDns1Swh/eMWdarMUC/LxdXtVnNgfIjSomkxkbWAUFLVN4Y
         o3KoIwx5IHN3f11GEmNsxNgMhxEiN10KP2wtCmTVHc8hp3vnivqwnJJQV4eJd0R9ofT2
         k2yGeskmbuaXPTDbuR6KdmWG3zg7fHgt/TsgM=
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 21:43:26 -0800
Message-ID: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>
Subject: Elaboration on "Equivalent fix must already exist in Linus' tree"
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While extending the documentation for submitting Linux wireless bug
reports [1] we note the stable series policy on patches -- that of
having an equivalent fix already in Linus' tree. I find this
documented in Documentation/stable_kernel_rules.txt but I'm curious if
there is any other resource which documents this or elaborates on this
a bit more. I often tell people about this rule or push _really_ hard
on testing "upstream" but some people tend to not understand. I think
that elaborating a little on this can help and will hopefully create
more awareness around the importance of trees like Stephen's
linux-next tree.

[1] http://wireless.kernel.org/en/users/Documentation/Reporting_bugs
[2] git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

  Luis
