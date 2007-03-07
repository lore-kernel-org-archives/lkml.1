Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbXCGLfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbXCGLfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXCGLfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:35:25 -0500
Received: from smtp.nokia.com ([131.228.20.172]:42347 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbXCGLfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:35:23 -0500
Subject: Re: [RFC] [PATCH] Kconfig: enlarge printk buffer size limit
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070302091113.1920ca0f.randy.dunlap@oracle.com>
References: <1172842068.17031.55.camel@sauron>
	 <20070302091113.1920ca0f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 07 Mar 2007 13:33:48 +0200
Message-Id: <1173267228.3886.0.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Mar 2007 11:33:49.0312 (UTC) FILETIME=[798AA800:01C760AC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 09:11 -0800, Randy Dunlap wrote:
> That's simple enough, but you could also just add
> 	log_buf_len=huge_number

Yeah, thanks for the tip, although the Kconfig change would not hurt as
well.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

