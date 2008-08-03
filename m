Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbYHCIgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbYHCIgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 04:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYHCIgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 04:36:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:44679 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYHCIgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 04:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=h9ZlLOGi3LYUVU72fD9V6j/rqcImt0pFC6Oa7tnD3suOC0yWswaa8oMTGpQrEuUj53
         IXFOAXwa7mlP5dNBwNOXsu7ErXA3Y3Ny9K3Df3969vg1KqtLGC/So7qqRBjM6Jb5qO+6
         p3FcCQVBvEgdbJNkWVreLWdBGYxmWWTiYL678=
Message-ID: <48956E15.6070409@tuffmail.co.uk>
Date: Sun, 03 Aug 2008 09:36:37 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [Bug #11178] Secondary hard drive fails during both hibernation
 and resume.
References: <cbItfVMShGI.A.olC.UMLlIB@albercik> <5ZeQ4vXWqRC.A.q2E.4NLlIB@albercik>
In-Reply-To: <5ZeQ4vXWqRC.A.q2E.4NLlIB@albercik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed
> and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11178
> Subject		: Secondary hard drive fails during both hibernation and resume.
> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date		: 2008-07-30 04:53 (4 days old)
> Handled-By	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17043&action=view
>   
Please keep listed.

The problem and patch are recently confirmed by Hugh Dickins (on LKML)
and Dionisus Torimens (bugzilla duplicate).

Ta
Alan
