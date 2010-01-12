Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736Ab0ALNak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0ALNak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 08:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649Ab0ALNaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 08:30:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0ALNai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 08:30:38 -0500
Date: Tue, 12 Jan 2010 14:30:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: Re: [PATCH] hid: make USB device id constant
In-Reply-To: <4B4A076A.8020207@freemail.hu>
Message-ID: <alpine.LNX.2.00.1001121430250.30977@pobox.suse.cz>
References: <4B4A076A.8020207@freemail.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010, Németh Márton wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> The id_table field of the struct usb_device_id is constant in <linux/usb.h>
> so it is worth to make the initialization data also constant.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
