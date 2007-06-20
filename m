Return-Path: <linux-kernel-owner+w=401wt.eu-S1762884AbXFTUMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762884AbXFTUMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbXFTUMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:12:48 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:54221
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756429AbXFTUMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:12:47 -0400
Message-ID: <46798A37.6050007@hawkeye.stone.uk.eu.org>
Date: Wed, 20 Jun 2007 21:12:39 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Spinlock init
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

can rwlock_init and spin_lock_init be used outside of functions declared
__init. The spinlock documentation suggests that it can't but I'd like
someone to confirm that.

Sorry if this has already been answered but I couldn't find anything on it.

Jack
