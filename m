Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYBETSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYBETSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYBETR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:17:56 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:49924 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbYBETRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:17:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=t2yk3OVGoHSEShxj5ajeIwe2uHN9hbYLNV9bf39uegVQsr6YglPSA9RbV4zo6tVyr1OcOVwR3+FuSQ9eVVcyUDaIlAhXV6ngzVkaREmDpnXvQ7c2Ly5iHOxj7VFsQNE4uGQlR4KD8IGfM2M9fRnSrTqxuIusLQAQHraGjMGXc2c=
Date: Tue, 5 Feb 2008 20:17:24 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] udf: fix udf_build_ustr
Message-ID: <20080205191720.GA6332@joi>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-3-git-send-email-marcin.slusarz@gmail.com> <20080131104532.GB1461@duck.suse.cz> <20080131195730.GB6222@joi> <20080204193107.GN3426@duck.suse.cz> <20080204212733.GA12562@joi> <20080205152923.GE25464@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205152923.GE25464@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 04:29:23PM +0100, Jan Kara wrote:
> PS: I'm working on getting access to kernel.org so that I can run UDF git
> tree there so we try merging these patches with the new git when I set that
> up :).
Good to hear that :)

Marcin
