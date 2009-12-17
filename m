Return-Path: <linux-kernel-owner+w=401wt.eu-S965516AbZLQUGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965516AbZLQUGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbZLQUGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:06:14 -0500
Received: from senator.holtmann.net ([87.106.208.187]:33522 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759776AbZLQUGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:06:13 -0500
Subject: Re: [PATCH] HID: PTR_ERR return of wrong pointer in
 hidp_setup_hid()
From: Marcel Holtmann <marcel@holtmann.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1D01C9.3070305@gmail.com>
References: <4B1D01C9.3070305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 11:48:24 -0800
Message-Id: <1261079304.4041.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roel,

> Return the PTR_ERR of the correct pointer.

patch has been applied to my tree. Thanks.

Regards

Marcel


