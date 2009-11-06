Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZKFGBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZKFGBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 01:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZKFGBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 01:01:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbZKFGBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 01:01:50 -0500
Date: Fri, 6 Nov 2009 01:01:54 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Thibaut Varene <T-Bone@parisc-linux.org>
Subject: Re: [PATCH 06/11] sysctl: parisc Use the compat_sys_sysctl
Message-ID: <20091106060154.GE11702@bombadil.infradead.org>
References: <m1tyx8trik.fsf@fess.ebiederm.org> <1257468114-6823-6-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257468114-6823-6-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 04:41:49PM -0800, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that we have a generic 32bit compatibility implementation
> there is no need for parisc to implement it's own.
> 
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Thibaut Varene <T-Bone@parisc-linux.org>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
