Return-Path: <linux-kernel-owner+w=401wt.eu-S1751313AbZHZOqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbZHZOqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZHZOqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:46:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZHZOqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:46:32 -0400
Message-ID: <4A954A98.5070808@redhat.com>
Date: Wed, 26 Aug 2009 10:45:44 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ric Wheeler <rwheeler@redhat.com>, david@lang.hm,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
References: <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A94B8FE.8050307@redhat.com> <20090826112219.GE26595@elf.ucw.cz>
In-Reply-To: <20090826112219.GE26595@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> Sledgehammer is hardware problem, and I'm demonstrating
> software/documentation problem we have here.

So your argument is that a sledgehammer is a hardware
problem, while a broken hard disk and a power failure
are software/documentation issues?

I'd argue that the broken hard disk and power failure
are hardware issues, too.

-- 
All rights reversed.
