Return-Path: <linux-kernel-owner+w=401wt.eu-S2993422AbXEBP57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993422AbXEBP57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993425AbXEBP57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:57:59 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:4007 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993422AbXEBP56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BT2JpKPyTGWk0keotv8GVFAnKJTs2NN4J/+ggyBsFNCrn9h7OYuiM+uS1N1TG7CQeMUebpsH8BasgASoSDRsdSU7CwkeQx9SqmW41Ylx0DtGuKoTJbsKScyuKsYAB7IBU9xUxIDf0amsWw0y/Kzy3dxh2pX1jYtP7UAcuRDSzeQ=
Message-ID: <4af2d03a0705020857g9af0de1v4f65db7f3b18d19a@mail.gmail.com>
Date: Wed, 2 May 2007 17:57:56 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/21] Char: cyclades, use IS_CYC_Z macro
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1726067771982725064@wsc.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1726067771982725064@wsc.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> cyclades, use IS_CYC_Z macro
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>
> ---
> commit 167ae9073fef562913c9d68d32da883da5444fbc
> tree 5d5795a789e6ce98a5a1226cf88e2b98b1d9a12a
> parent b462f2fd89bff92e55be6a5317a3be0ad6a93ad8
> author Jiri Slaby <jirislaby@gmail.com> Tue, 24 Apr 2007 21:40:00 +0200
> committer Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 13:14:54 +0200
>
>  drivers/char/cyclades.c |   17 ++++++-----------
>  1 files changed, 6 insertions(+), 11 deletions(-)

Andrew, did this patchset reach you, please?
01-cyclades-use-is-cyc-z-macro.patch
02-cyclades-switch-to-pci-probing.patch
03-cyclades-depends-on-pci-or-isa.patch
04-cyclades-unexport-struct-cyclades-card.patch
05-cyclades-remove-useless-fileds-from-cyclades-card.patch
06-cyclades-irq-is-int.patch
07-cyclades-printk-cleanups.patch
08-cyclades-mark-cyy-init-card-as---devinit-not---init.patch
09-cyclades-simplify-variables-initialization.patch
10-cyclades-get-rid-of-phys-addresses.patch
11-cyclades-make-info-card-a-pointer.patch
12-cyclades-remove-sleep-on.patch
13-cyclades-fix-blockmove.patch
14-cyclades-timers-cleanup.patch
15-cyclades-remove-unused-timestamps.patch
16-cyclades-remove-locking-macros.patch
17-cyclades-conditions-cleanup.patch
18-cyclades-fix-tty-device-unregister.patch
19-cyclades-dynamic-ports.patch
20-cyclades-probe-cleanup.patch
21-cyclades-copyright-and-version-changes.patch

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
