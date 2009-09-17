Return-Path: <linux-kernel-owner+w=401wt.eu-S1751243AbZIQVpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbZIQVpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZIQVpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:45:43 -0400
Received: from outbound-mail-307.bluehost.com ([67.222.53.253]:39145 "HELO
	outbound-mail-307.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750741AbZIQVpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:45:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bRx8ETKmg7DGXtAg3Ck/inVjiSsb4rUgTznf31xo5a0YmtQGUvbM7k+i/oFsqTf7WFwNIPZ7Rgp+IkVaU/CiFfVmUgXJTReVZidpOpYXyBeVlE5pwEKL54VZ/QI2uqVb;
Date: Thu, 17 Sep 2009 14:45:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: airlied@gmail.com, intel-gfx@lists.freedesktop.org,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Stable Team <stable@kernel.org>
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915: remove restore in resume
Message-ID: <20090917144538.29b7244b@jbarnes-g45>
In-Reply-To: <1252896427-11669-2-git-send-email-zhenyuw@linux.intel.com>
References: <1252896427-11669-1-git-send-email-zhenyuw@linux.intel.com>
	<1252896427-11669-2-git-send-email-zhenyuw@linux.intel.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 10:47:07 +0800
Zhenyu Wang <zhenyuw@linux.intel.com> wrote:

> Don't need extra config restore like for intel_agp, which
> might cause resume hang issue found by Alan on 845G.
> 
> Cc: Stable Team <stable@kernel.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---

Applied to drm-intel-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
