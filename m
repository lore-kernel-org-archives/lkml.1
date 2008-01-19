Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYASUR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYASUR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 15:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYASURS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 15:17:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:13455 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYASURR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 15:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gCtwBMh6Zc8g3yl5XNNrDE7l7uDeyDPryXMBh39ptQ5lhgOJnvbDSBvnqzlPEw/pdLSe1DGwUHcBhsX+mibD7rLfsw/JgADgrIthmpd/KH5umN34RVAeqhQZhdMNBIOEvhDMbnlYom6aTo0NrRwSABET0P/C85ENn03W4enSeHk=
Message-ID: <38b2ab8a0801191217m6d4a44edw28dfc6f60b5bf9f8@mail.gmail.com>
Date: Sat, 19 Jan 2008 21:17:15 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "James Cloos" <cloos@jhcloos.com>
Subject: Re: Why not creating a GIT RT tree ?
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <m3zlv2kd6t.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com>
	 <m3zlv2kd6t.fsf@lugabout.jhcloos.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Jan 18, 2008 10:59 PM, James Cloos <cloos@jhcloos.com> wrote:
> >>>>> "Francis" == Francis Moreau <francis.moro@gmail.com> writes:
>
> Francis> I can't find a rt tree anywhere and all new rt release spoke
> Francis> about a patchset to apply on mainline kernels.
>
> It is not perfect, but I do have a git repo of the rt history-of-patches
> up at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/cloos/rt-2.6.git
> http://www.kernel.org/pub/scm/linux/kernel/git/cloos/rt-2.6.git
>
> Gitweb URL is:
>
> http://git.kernel.org/?p=linux/kernel/git/cloos/rt-2.6.git
>
> It is in the one-head per patch style, and has the single-file patches
> applied rather than the quilt queue.

Why don't you have one commit per patch ?

Thanks
-- 
Francis
