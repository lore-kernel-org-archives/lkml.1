Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZCBXMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZCBXMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZCBXM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:12:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbZCBXM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:12:26 -0500
Date: Mon, 2 Mar 2009 15:07:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: djwong@us.ibm.com
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] lm90: Support the MAX6648/6692 chips
Message-Id: <20090302150742.0894eaad.akpm@linux-foundation.org>
In-Reply-To: <20090302210106.GD6550@plum>
References: <20090302210106.GD6550@plum>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three patches look like 2.6.29 material to me.  If none of
them pop up in linux-next I'll plan to merge them a few days from now.

OK?
