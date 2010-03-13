Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab0CMDxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:53:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:33724 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab0CMDxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 22:53:50 -0500
Date: Fri, 12 Mar 2010 19:54:10 -0800
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland Dreier <rdreier@cisco.com>,
       Alexander Beregalov <a.beregalov@gmail.com>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
Message-ID: <20100313035410.GA12084@suse.de>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com> <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com> <m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org> <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org> <4B99A7B9.3000802@kernel.org> <4B9B0836.7080508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9B0836.7080508@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 07:36:22PM -0800, Yinghai Lu wrote:
> ---
>  drivers/net/mlx4/main.c |    1 +
>  1 file changed, 1 insertion(+)

No change log entry + no Signed-off-by: line = email deleted

It's as if we write documentation on how to do all of this to just watch
no one read it :(
