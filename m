Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZJSOUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZJSOUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbZJSOUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:20:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:45741 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbZJSOUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:20:07 -0400
Date: Mon, 19 Oct 2009 16:20:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5/7] acpi: fix a bunch of style issues on 'actypes.h'
In-Reply-To: <1255906474-25091-6-git-send-email-felipe.contreras@gmail.com>
Message-ID: <alpine.LSU.2.00.0910191616290.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-6-git-send-email-felipe.contreras@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> Many still remain.
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

I have never been in favor of merging whitespace-only patches (in a sense 
that the sole purpose of them being to change whitespaces, but no else 
value added). 

And after today's discussion on kernel summit on this topic, I wouldn't 
expect any maintainer to merge it, sorry :)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
