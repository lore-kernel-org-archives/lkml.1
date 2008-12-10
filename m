Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYLJKTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYLJKTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 05:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYLJKSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 05:18:55 -0500
Received: from senator.holtmann.net ([87.106.208.187]:33630 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbYLJKSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:18:54 -0500
Subject: Re: [PATCH] dynamic_printk: add line feed to printk
From: Marcel Holtmann <marcel@holtmann.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20081210073347.GA18737@localhost>
References: <20081210073347.GA18737@localhost>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 11:18:46 +0100
Message-Id: <1228904326.19553.127.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Append '\n' to two printk messages.

I already sent a patch for that and Greg picked it up.

> Also cleanup the code to reduce one level of indentation.

Please re-base that one against Greg's latest tree that includes my
patch.

Regards

Marcel


