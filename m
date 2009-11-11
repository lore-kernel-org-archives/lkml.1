Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbZKKVPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbZKKVPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbZKKVPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:15:18 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44518 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbZKKVPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:15:17 -0500
Date: Wed, 11 Nov 2009 16:07:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/23] sysctl: Stop using binary sysctl numbers in
	arlan.
Message-ID: <20091111210730.GL4392@tuxdriver.com>
References: <m14op5jjo4.fsf@fess.ebiederm.org> <1257682930-31401-2-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257682930-31401-2-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 04:21:49AM -0800, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Looking at the arlan code it appears all of the sysctl
> entries are disabled debug code, and have not been enabled
> since the driver was merged in feb of 2003.
> 
> Since except for a select few that userspace can't
> get along without the binary sysctl table entries
> are going away.  Kill the unused arlan binary sysctls.
> 
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
