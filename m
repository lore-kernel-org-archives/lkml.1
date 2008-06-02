Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYFBQJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYFBQJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYFBQJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:09:08 -0400
Received: from gw.goop.org ([64.81.55.164]:57649 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYFBQJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:09:07 -0400
Message-ID: <48441AFF.3020204@goop.org>
Date: Mon, 02 Jun 2008 17:08:31 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: More e820 unification?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Are you looking at completely unifying e820_32/64.c?  It looks like the 
delta between them is fairly small.

Thanks,
    J
