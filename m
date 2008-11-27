Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYK0QEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYK0QEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYK0QD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:03:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYK0QD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:03:56 -0500
Date: Thu, 27 Nov 2008 17:03:53 +0100
From: Karel Zak <kzak@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx, util-linux-ng@vger.kernel.org
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default
	behaviour
Message-ID: <20081127160353.GQ2961@nb.net.home>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127150341.GB20941@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 03:03:41PM +0000, Matthew Garrett wrote:
> Also add a MS_NORELATIME mount option
[...]
> +#define MS_NORELATIME	(1<<24)	/* Disable relatime even if the default */

 CC: util-linux-ng@vger.kernel.org

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
