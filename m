Return-Path: <linux-kernel-owner+w=401wt.eu-S934902AbYEBMWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902AbYEBMWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765591AbYEBMVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:21:55 -0400
Received: from senator.holtmann.net ([87.106.208.187]:44514 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762082AbYEBMVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:21:54 -0400
Subject: Re: [PATCH 4/6] bluetooth: use get/put_unaligned_* helpers
From: Marcel Holtmann <marcel@holtmann.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209705573.22362.40.camel@brick>
References: <1209705573.22362.40.camel@brick>
Content-Type: text/plain
Date: Fri, 02 May 2008 14:22:37 +0200
Message-Id: <1209730957.28146.41.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  net/bluetooth/bnep/core.c |    8 ++++----
>  net/bluetooth/hci_event.c |    9 ++++-----
>  net/bluetooth/hci_sock.c  |    2 +-
>  net/bluetooth/l2cap.c     |    2 +-
>  4 files changed, 10 insertions(+), 11 deletions(-)

thanks for doing this cleanup. Makes the core a lot easier to read. I am
okay if this change goes directly via netdev or -mm.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


