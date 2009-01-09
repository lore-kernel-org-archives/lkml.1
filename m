Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZAIXPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZAIXPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZAIXPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:15:45 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:37864 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZAIXPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:15:44 -0500
Date: Fri, 9 Jan 2009 15:15:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Subject: Reported-by (Re: Fix a typo in the development process document.)
Message-Id: <20090109151535.336c3afd.randy.dunlap@oracle.com>
In-Reply-To: <200901090059.n090xfIH030955@hera.kernel.org>
References: <200901090059.n090xfIH030955@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4967DA9A.0065:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 00:59:41 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d5b524327b2a482dddae3839ced8f8825074730d
> Commit:     d5b524327b2a482dddae3839ced8f8825074730d
> Parent:     2884f00b94be73a6a7875bada739bf9bb2f9a1b6
> Author:     Jonathan Corbet <corbet@lwn.net>
> AuthorDate: Thu Jan 8 16:32:13 2009 -0700
> Committer:  Jonathan Corbet <corbet@lwn.net>
> CommitDate: Thu Jan 8 16:32:13 2009 -0700
> 
>     Fix a typo in the development process document.
>     
>     Reported-by: Aníbal Monsalve Salazar <anibal@debian.org>
>     Signed-off-by: Jonathan Corbet <corbet@lwn.net>


BTW, Jon, if Reported-by: is supposed to have a status that is (nearly)
as well accepted as most of the other tags, then it should be documented
in SubmittingPatches along with the other tags and not only in
development-process/5.Posting, no?

Or maybe it's not as well accepted as the others...
  http://www.remword.com/kps_result/2_6_29_report.html


---
~Randy
