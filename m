Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbXH1U2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbXH1U2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXH1U2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:28:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:63885 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbXH1U2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:28:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kmAEUNXtyhPe0tihao+yJdVL1TbL1RhGzu4JDHthE7+5DhCAd9UIUyt6NpPO5YBObcGQWemnNN0p7q2IkCTqxE1p+/51KaMaPNl1CaqGdui0Ckjl+So9q+xxq2k9dbs9HRA4pT58B2gyTivhkywMa8C3edpFFyWfTdw/c4YuXTs=
Message-ID: <b79f23070708281328m170d2d56h658741f6b93ebf05@mail.gmail.com>
Date: Tue, 28 Aug 2007 13:28:17 -0700
From: "James Ausmus" <james.ausmus@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc3 issues: AMD64 laptop hard-reboots soon after executing init
In-Reply-To: <b79f23070708231547x1b3b943fkdd19e0b3a90886fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b79f23070708231547x1b3b943fkdd19e0b3a90886fd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/07, James Ausmus <james.ausmus@gmail.com> wrote:
> That pretty much sums it up - It's an x86_64 system, I pulled my
> 2.6.20 .config file over, verified settings in make menuconfig, built
> it, and, if I use my normal init system (Gentoo distro), the laptop
> does a hard reboot just a little bit before I would hit a login
> prompt. If I append init=/bin/bash, I get the same behaviour after
> about the same time (but I do get a bash prompt).

<snip>

Problem seems to be solved with rc4.

Thanks!

-James
