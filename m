Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYDCWwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYDCWwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 18:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYDCWwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 18:52:08 -0400
Received: from ozlabs.org ([203.10.76.45]:41810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbYDCWwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 18:52:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/7] virtio: fix sparse return void-valued expression warnings
Date: Fri, 4 Apr 2008 08:51:37 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
References: <1207182814.5740.20.camel@brick>
In-Reply-To: <1207182814.5740.20.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804040851.37778.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008 10:33:34 Harvey Harrison wrote:
> drivers/virtio/virtio_pci.c:148:2: warning: returning void-valued
> expression drivers/virtio/virtio_pci.c:155:2: warning: returning
> void-valued expression

Hi Harvey,

This patch is in my tree, thanks.

Rusty.
