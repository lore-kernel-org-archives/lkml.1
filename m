Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZH1OuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZH1OuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 10:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbZH1OuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 10:50:06 -0400
Received: from mail.lang.hm ([64.81.33.126]:38638 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZH1OuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 10:50:04 -0400
Date: Fri, 28 Aug 2009 07:49:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rob Landley <rob@landley.net>
cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
In-Reply-To: <200908271551.43840.rob@landley.net>
Message-ID: <alpine.DEB.2.00.0908280748080.6822@asgard.lang.hm>
References: <20090824212518.GF29763@elf.ucw.cz> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <200908271551.43840.rob@landley.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Rob Landley wrote:

> Pavel's response was to attempt to document this.  Not that journaling is
> _bad_, but that it doesn't protect against this class of problem.

I don't think anyone is disagreeing with the statement that journaling 
doesn't protect against this class of problems, but Pavel's statements 
didn't say that. he stated that ext3 is more dangerous than ext2.

David Lang
