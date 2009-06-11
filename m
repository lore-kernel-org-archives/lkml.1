Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZFKU4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZFKU4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZFKU43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:56:29 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:64889 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZFKU42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kRiHKWR8vQ8QW1fP/Km8rF1lK2/OHCU59oJKB0GVi7zViWxy9JAlPKwOKg1UCMUTBZ
         Do5GvNasJRlGKUp698H/YkCJvoA9BHOWTEN9QprAjZq6hDWVZTWv4STmlDygpnLy9WyJ
         EsLdWMTdWcB1njBIQ7wDPhPrfUL0NPXjQl7EQ=
MIME-Version: 1.0
In-Reply-To: <43e72e890906111240x13ee658av6b89268c3950a2c@mail.gmail.com>
References: <43e72e890906111240x13ee658av6b89268c3950a2c@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Jun 2009 13:56:10 -0700
Message-ID: <43e72e890906111356h96d12fdr5d0d1f9c73521c92@mail.gmail.com>
Subject: Re: Stable compat-wireless release for 2.6.30
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 12:40 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> Since 2.6.30 is out the respective compat-wireless stable tarball has
> been updated based on this release and posted on the project page [1].
> If you just want to test the wireless bits of 2.6.30 you can do so
> with this release, works on kernels >= 2.6.27. Bugs found here are
> very likely bugs on 2.6.30 and should be reported on the
> linux-wireless mailing list [2]. For a summary of the wireless bits
> that were changed you can refer to our news entry for it [3]. If you
> have no luck with that please try our bleeding edge releases based on
> wireless-testing [4]. Issues with bleeding edge should also be
> reported the linux-wireless mailing list.
>
> [1] http://wireless.kernel.org/en/users/Download/stable
> [2] http://wireless.kernel.org/en/developers/MailingLists
> [3] http://wireless.kernel.org/News/2009-06-09
> [4] http://wireless.kernel.org/en/users/Download

Oh and of course for more one-on-one support our IRC channel, details at:

http://wireless.kernel.org/en/users/Support

  Luis
