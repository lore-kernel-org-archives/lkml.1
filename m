Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZJLPep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZJLPep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZJLPeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:34:44 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:55713 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZJLPen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:34:43 -0400
Date: Mon, 12 Oct 2009 08:33:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [patch] perf build questions
Message-Id: <20091012083333.48833843.randy.dunlap@oracle.com>
In-Reply-To: <20091012063547.GB14377@elte.hu>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com>
	<20091012063547.GB14377@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AD34C57.00C9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 08:35:47 +0200 Ingo Molnar wrote:

> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > Also, I see build errors/warnings (-Werror).  Others aren't seeing these?
> > Just due to my gcc version?
> 
> Thanks for the fix. Which GCC version is this btw?

gcc (GCC) 4.2.1 (SUSE Linux)
(from some openSUSE.org release)

---
~Randy
