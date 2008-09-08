Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYIHSdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYIHSdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYIHSdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:33:25 -0400
Received: from hs-out-0708.google.com ([64.233.178.240]:31087 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYIHSdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:33:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XWuZ4DtTHQRSYFguf8Dn6t1WHSpfpQSenBkhKk6jy25Y8l3TT4uhGhgGv4jajjYpow
         Pa2TDzEIJqnCVn3mA1YtyPpCEw/kJ+kfRrY1h8BBzms20lXd4RmObO4BJLVlpiV7zx7t
         IUGN9FhTOOoeMaXB23H93hMXUS+6a2n7qzHEE=
Message-ID: <36ca99e90809081133s58e3d32h8b85804f5bb76902@mail.gmail.com>
Date: Mon, 8 Sep 2008 20:33:23 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [ANNOUNCE] Guilt v0.31
Cc: "Git Mailing List" <git@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       guilt@lists.josefsipek.net, "Brandon Philips" <brandon@ifup.org>
In-Reply-To: <20080908135244.GB27550@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080908135244.GB27550@josefsipek.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 8, 2008 at 15:52, Josef 'Jeff' Sipek <jeffpc@josefsipek.net> wrote:
> Guilt v0.31 is available for download.

Is it possible to include pre-generated docs in the tarballs?

I downloaded one and run 'make doc' and get these messages:

fatal: Not a git repository

which looks like it comes from this line in Documentation/Makefile:

VERSION=$(shell git describe)

Its not critical, but looks awkward.

Thanks

Bert
