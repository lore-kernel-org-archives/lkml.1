Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZHCH36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZHCH36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 03:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZHCH35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 03:29:57 -0400
Received: from ozlabs.org ([203.10.76.45]:57654 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbZHCH35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 03:29:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fernando Luis =?utf-8?q?V=C3=A1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH] Add virtio IDs file
Date: Mon, 3 Aug 2009 16:59:52 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org
References: <4A728E74.1070805@oss.ntt.co.jp>
In-Reply-To: <4A728E74.1070805@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908031659.52527.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 03:55:56 pm Fernando Luis Vázquez Cao wrote:
> Virtio IDs are spread all over the tree which makes assigning new IDs
> bothersome. Putting them together should make the process less error-prone.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Seems like a good idea to me!  Applied.

(I added a #ifndef _LINUX_VIRTIO_IDS_H wrapper around it, too).

Thanks!
Rusty.
PS.  Whitespace damage in this and your previous patch?  Fixed.
