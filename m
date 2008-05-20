Return-Path: <linux-kernel-owner+w=401wt.eu-S1763390AbYETTw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390AbYETTw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbYETTwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:52:18 -0400
Received: from lap75545.ornl.gov ([160.91.210.54]:60992 "EHLO
	lap75545.ornl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880AbYETTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:52:17 -0400
X-Greylist: delayed 2896 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 15:52:17 EDT
Subject: Re: [PATCH 03/21] drivers/net: use aligned-endian get/put helpers
From: David Dillow <dave@thedillows.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1211306732.5915.169.camel@brick>
References: <1211306732.5915.169.camel@brick>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 20 May 2008 15:03:20 -0400
Message-Id: <1211310200.23659.19.camel@lap75545.ornl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-20 at 11:05 -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/net/typhoon.c                      |   12 ++++++------

Acked-by: David Dillow <dave@thedillows.org>
