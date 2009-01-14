Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbZANU0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbZANU0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbZANU0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:26:11 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:28405 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZANU0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:26:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=RsH2ri90MYIpJijoX3jJfiNLTIWsiLYYw1PhwuJje8m7ISuIjsiXy3bD4Dlo6e7xXX
         395I+DTczHz43/6D0PgG1tm3D3xRgpbQx+ucMvP2UfbOBx4XjquUnWOoE59PFwkJtgyu
         Y22XbdJYoUmpxpwADchLGxhKjrYOt5BS7WWY4=
Message-ID: <55fdf7050901141226qca33de3o6ff88d4eecb5a125@mail.gmail.com>
Date: Wed, 14 Jan 2009 12:26:08 -0800
From: "LINUX NEWBIE" <lnxnewbie@gmail.com>
To: linux-kernel@vger.kernel.org, stoth@hauppauge.com
Subject: cx23885 LINUX
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    May I ask you some questions?  For 885 driver in cx23885-video.c,
in function buffer_queue(), what is the difference between q->queued
and q->active?

    Also, you check if q->queued is NOT empty, then add to list.  But
why do you add q->active to list when it's empty?

    I'm learning how DMA and Risc works in cx23885 linux driver.  Your
help is appreciated.

Thanks.
