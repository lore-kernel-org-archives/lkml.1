Return-Path: <linux-kernel-owner+w=401wt.eu-S935070AbXK3P3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935070AbXK3P3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762379AbXK3P3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:29:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762313AbXK3P3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:29:02 -0500
Date: Fri, 30 Nov 2007 10:28:37 -0500
From: Dave Jones <davej@redhat.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: git + checkpatch.pl?
Message-ID: <20071130152837.GA8116@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	linux-kernel@vger.kernel.org
References: <DF3E6A31-61AA-44B2-90C0-7001976E5691@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DF3E6A31-61AA-44B2-90C0-7001976E5691@kernel.crashing.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 09:18:59AM -0600, Kumar Gala wrote:
 > Does any know if there is a way to run checkpatch.pl over the index  
 > before one does a commit?

git diff | scripts/checkpatch.pl

?

	Dave
-- 
http://www.codemonkey.org.uk
