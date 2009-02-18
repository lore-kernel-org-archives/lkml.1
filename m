Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZBRE6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZBRE6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 23:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZBRE6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 23:58:36 -0500
Received: from ozlabs.org ([203.10.76.45]:48159 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbZBRE6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 23:58:35 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Wed, 18 Feb 2009 15:28:29 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
References: <1234722028-8110-1-git-send-email-andr345@gmail.com> <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com> <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
In-Reply-To: <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181528.29697.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009 22:23:25 Kay Sievers wrote:
> Monolithic versus modular kernels usually
> make about 2+ seconds difference on a recent laptop.

Thanks for the fact injection.  How about a megamodule then?

Cheers,
Rusty.
