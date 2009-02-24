Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZBXBjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZBXBjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZBXBjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:39:12 -0500
Received: from ozlabs.org ([203.10.76.45]:39744 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZBXBjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:39:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Tue, 24 Feb 2009 12:09:03 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       heiko.carstens@de.ibm.com
References: <1234722028-8110-1-git-send-email-andr345@gmail.com> <200902201128.55959.rusty@rustcorp.com.au> <ac3eb2510902191733s700cbdd5k55f8593e2151d306@mail.gmail.com>
In-Reply-To: <ac3eb2510902191733s700cbdd5k55f8593e2151d306@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241209.04473.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009 12:03:57 Kay Sievers wrote:
> That looks very different to the numbers without this patch and the
> otherwise same setup, where we get heavy noise in the traces and many
> delays of up to 200 millisecs until linking, most of them taking 30+
> millisecs.

Hi Kay,
	I've added quotes from your mail and a Tested-by: from you.  It will go
in tomorrow's linux-next.

Thanks!
Rusty.
