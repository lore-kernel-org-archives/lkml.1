Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbZH1HMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbZH1HMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZH1HMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:12:09 -0400
Received: from mx01.bfk.de ([193.227.124.2]:56084 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbZH1HMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:12:08 -0400
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Rob Landley <rob@landley.net>,
       Theodore Tso <tytso@mit.edu>, Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret
References: <20090824212518.GF29763@elf.ucw.cz>
	<20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com>
	<200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com>
	<20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>
From: Florian Weimer <fweimer@bfk.de>
Date: Fri, 28 Aug 2009 07:11:45 +0000
In-Reply-To: <4A9733C1.2070904@redhat.com> (Ric Wheeler's message of "Thu\, 27 Aug 2009 21\:32\:49 -0400")
Message-ID: <827hwos98u.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ric Wheeler:

> You continue to ignore the technical facts that everyone (both MD and
> ext3) people put in front of you.
>
> If you have a specific bug in MD code, please propose a patch.

In RAID 1 mode, it should read both copies and error out on
mismatch. 8-)

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
