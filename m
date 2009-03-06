Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZCFBKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZCFBKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 20:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZCFBKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 20:10:40 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54270 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZCFBKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 20:10:39 -0500
Date: Thu, 5 Mar 2009 18:10:36 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
Message-ID: <20090306011036.GB829@parisc-linux.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903040815.38387.prakash@punnoor.de> <20090305171514.GB1021@parisc-linux.org> <200903060045.13509.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903060045.13509.prakash@punnoor.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 12:45:12AM +0100, Prakash Punnoor wrote:
> Something like this would be minimal and works for me:

Looks appropriate for a -rc7 fix.  Unless anyone argues, I'll put this
in the pci-fixes tree that I'll push out tomorrow.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
