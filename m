Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbZKYWMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbZKYWMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbZKYWL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:11:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759383AbZKYWL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:11:59 -0500
Date: Wed, 25 Nov 2009 14:11:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <jw@emlix.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] rtc-x1205: fix rtc_time to y2k register value
 conversion
Message-Id: <20091125141100.d9348bd5.akpm@linux-foundation.org>
In-Reply-To: <1259166736-31006-1-git-send-email-jw@emlix.com>
References: <1259166736-31006-1-git-send-email-jw@emlix.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm thinking that patches 1 and 2 are 2.6.32 material?
