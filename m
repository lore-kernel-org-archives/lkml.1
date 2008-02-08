Return-Path: <linux-kernel-owner+w=401wt.eu-S935544AbYBHUif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935544AbYBHUif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935432AbYBHUhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:37:53 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34395 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935426AbYBHUhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:37:51 -0500
Date: Fri, 8 Feb 2008 21:37:58 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Barry Kasindorf <barry.kasindorf@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] AMD Family10h IBS support for oProfile driver
Message-ID: <20080208203758.GF31984@uranus.ravnborg.org>
References: <47ACB56A.1030407@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ACB56A.1030407@amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 03:02:50PM -0500, Barry Kasindorf wrote:
> 
> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> 
> This patchset supports the new IBS profiling hardware available in the 
> latest AMD CPUs in the oProfile driver.
Please use descriptive subjects for each patch.
As it stands now we will end up with three identical named commits.

	Sam
