Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbZCCWkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbZCCWkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbZCCWkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:40:10 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33921 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057AbZCCWkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:40:09 -0500
Date: Tue, 3 Mar 2009 16:40:07 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dan Smith <danms@us.ibm.com>
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] c/r: define s390-specific checkpoint-restart code
	(v7)
Message-ID: <20090303224007.GA4150@us.ibm.com>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com> <1236095764-19325-4-git-send-email-danms@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236095764-19325-4-git-send-email-danms@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Smith (danms@us.ibm.com):
> Implement the s390 arch-specific checkpoint/restart helpers.  This
> is on top of Oren Laadan's c/r code.

Working nicely for me, thanks.

-serge
