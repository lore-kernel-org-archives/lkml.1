Return-Path: <linux-kernel-owner+w=401wt.eu-S1765629AbYEFQpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765629AbYEFQpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbYEFQpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:45:22 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:40188 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbYEFQpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:45:20 -0400
Message-ID: <fa686aa40805060945i31433e3bg3fb4fce825b30072@mail.gmail.com>
Date: Tue, 6 May 2008 10:45:19 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Greg KH" <greg@kroah.com>, stable@kernel.org
Subject: Re: Fwd: [PATCH] [POWERPC] mpc5200: Fix unterminated of_device_id table
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080506154408.GA32680@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429124343.24177.15349.stgit@trillian.secretlab.ca>
	 <fa686aa40805060741vd4befa4i1ea5ab6df4d54d9b@mail.gmail.com>
	 <20080506154408.GA32680@kroah.com>
X-Google-Sender-Auth: 1950ab2b7c3aff42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 9:44 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, May 06, 2008 at 08:41:44AM -0600, Grant Likely wrote:
>  > Greg,
>  >
>  > This patch is already in mainline; but it needs to be backported to
>  > the stable tree.  Can you please pick it up?
>
>  In the future, please email the stable@kernel.org alias for things you
>  want to go into the stable tree, otherwise there is a very good chance
>  it will be missed.
>
>  Also, please mention the git id for the commit in Linus's tree so we
>  don't have to go digging for it.

Will do, Thanks Greg.

The git id is: bc775eac63c16dbcfabc4c6e949c0228edf3e11f

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
