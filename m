Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZHZDvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZHZDvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 23:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZHZDvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 23:51:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbZHZDvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 23:51:50 -0400
Message-ID: <4A94B120.7020607@redhat.com>
Date: Tue, 25 Aug 2009 23:50:56 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
References: <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz>
In-Reply-To: <20090825235359.GJ4300@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> If you want to argue that ext3/MD RAID5/no UPS combination is still
> less likely to fail than single SATA disk given part fail
> probabilities, go ahead and present nice statistics. Its just that I'm
> not interested in them.

The reality in your document does not match up with the reality
out there in the world.  That sounds like a good reason not to
have your (incorrect) document out there, confusing people.

-- 
All rights reversed.
