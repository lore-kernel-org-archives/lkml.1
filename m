Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbXCMKIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbXCMKIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbXCMKIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:08:17 -0400
Received: from outmx001.isp.belgacom.be ([195.238.5.51]:58906 "EHLO
	outmx001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbXCMKIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:08:14 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Maximus <john.maximus@gmail.com>
Subject: Re: Porting V4L2 drivers to 2.6.20
Date: Tue, 13 Mar 2007 11:08:02 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <3634de740703130300j12928fbeob860c067e46badbf@mail.gmail.com>
In-Reply-To: <3634de740703130300j12928fbeob860c067e46badbf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131108.03090.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hey,
>          am porting V4L2 drivers from 2.6.13 to 2.6.20.
>
>      The driver is using a  structure 'video_device' which exists in
> include/linux/videodev.h.
>
>      However, The linux kernel in 2.6.20 doesnot have that structure?.
>
>       Has the architecture changed between 2.6.13 to 2.6.20 for V4L2?.

The structure has been moved to include/media/v4l2-dev.h

Best regards,

Laurent Pinchart
