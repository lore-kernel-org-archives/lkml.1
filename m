Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbYCFTwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbYCFTwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbYCFTwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:52:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:24905 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbYCFTwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=m2WzljDXv+z9w/iWkwT22mwNJzlcNCsMb4kEZ/F0GRKTIyOQOZlbIVbT+B6UYmQ0gPJcxp9GFmQF1KrjdSGJADZhGk4z4vGiIWyr9ey7/Nk1t27KAnRztGDw5buJHUQC1G9RYNhF5pEsRqvJLA7O8dekbXrATpNF2DGp9JLKP8w=
Date: Thu, 6 Mar 2008 22:51:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: FW: Linux question
Message-ID: <20080306195116.GC7547@cvg>
References: <DEE40752C8AF224BB890E455C7B8E0FE042B84B112@G6W0268.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DEE40752C8AF224BB890E455C7B8E0FE042B84B112@G6W0268.americas.hpqcorp.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Miller, Mike (OS Dev) - Thu, Mar 06, 2008 at 07:33:09PM +0000]
| Is there a way in to limit the kernel to seeing only the cores on a single
| processor and ignore all other processor cores (eg. leave them in HALT)?
| --

You may try to play with "nosmp" boot parameter, but i'm not sure
that is exactly you wanted.

		- Cyrill -
