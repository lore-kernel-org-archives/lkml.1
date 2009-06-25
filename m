Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbZFYOhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbZFYOhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZFYOhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:37:32 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:56186 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFYOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SxLGbMFu8Rx0FLyuBhTY6gzOLI3NLeTm8aXD8Hjovk2IORKhvg8EyYlLRw47KCn80L
         WAWeijeYe33sP95+ZySb8b34iw+r1LjPmPcnTFivU39tpUdvFVoBpedPjOyBOQLtgnUD
         bYOOyM0MvCaXo2cNJEbg4GEFTEQgZ4OzzgBFU=
Message-ID: <4A438BA7.9010800@tuffmail.co.uk>
Date: Thu, 25 Jun 2009 15:37:27 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: 2.6.30-rc1: touchpad disabled on hibernation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The synaptics touchpad on my EeePC 701 dies on hibernation.  2.6.30 was
fine, and it doesn't happen on suspend to ram either.  There are no
obvious error messages, but maybe this boot message is relevant:

Platform driver 'i8042' needs updating, please use dev_pm_ops

Alan
