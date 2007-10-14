Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbXJNEur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbXJNEur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbXJNEuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:50:37 -0400
Received: from smtp05.mtu.ru ([62.5.255.52]:55308 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbXJNEug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:50:36 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [git pull] Input updates for 2.6.24-rc0
To: linux-kernel@vger.kernel.org
Date: Sun, 14 Oct 2007 08:50:33 +0400
References: <200710131614.35356.dmitry.torokhov@gmail.com>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20071014045034.8ECF4981D57@smtp05.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:

[...]
>       Input: tsdev - implement proper locking
[...]
>  delete mode 100644 drivers/input/tsdev.c

This fixes all locking issues indeed :)

