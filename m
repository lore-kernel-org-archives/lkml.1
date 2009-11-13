Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZKMVlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZKMVlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZKMVlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:41:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbZKMVlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:41:12 -0500
Date: Fri, 13 Nov 2009 22:41:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Moore, Robert" <robert.moore@intel.com>
Cc: Daniel Walker <dwalker@fifo99.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, "Lin, Ming M" <ming.m.lin@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 5/7] acpi: fix a bunch of style issues on 'actypes.h'
In-Reply-To: <4911F71203A09E4D9981D27F9D8308583E43CEEB@orsmsx503.amr.corp.intel.com>
Message-ID: <alpine.LSU.2.00.0911132239160.15039@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>  <1255906474-25091-6-git-send-email-felipe.contreras@gmail.com>  <alpine.LSU.2.00.0910191616290.8582@wotan.suse.de> <1258145921.6411.18.camel@c-dwalke-linux.qualcomm.com>
 <4911F71203A09E4D9981D27F9D8308583E43CEEB@orsmsx503.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009, Moore, Robert wrote:

> >> And after today's discussion on kernel summit on this topic, I 
> >> wouldn't expect any maintainer to merge it, sorry :)
> >could you be more specific about what "discussion" you are talking
> >about.
> Yes, do tell.

I have probably lost the track of the context here already, sorry.

But it probably had something to do with the fact that whitespace-only 
patches (which [PATCH 5/7] acpi: fix a bunch of style issues on 
'actypes.h' has been, as far as I remember), are unnecessary noise.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
