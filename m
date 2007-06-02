Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbXFBOk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbXFBOk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759149AbXFBOkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:40:52 -0400
Received: from zakalwe.fi ([80.83.5.154]:53764 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759048AbXFBOkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:40:52 -0400
Date: Sat, 2 Jun 2007 17:39:47 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Tear <tarrqt@yahoo.com>
Cc: mingo@redhat.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IO-APIC blacklist
Message-ID: <20070602143947.GJ10873@zakalwe.fi>
References: <477357.96605.qm@web63602.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <477357.96605.qm@web63602.mail.re1.yahoo.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 07:10:58AM -0700, Tear wrote:
> I would like this patch to be merged into the main
> tree. If there is any revision/correction that needs to
> be done on the patch, please let me know.

You forgot:

Signed-off-by: Random J Developer <random@developer.example.org>

(See Documentation/SubmittingPatches)

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
