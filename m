Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYCMVDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYCMVDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYCMVDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:03:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360AbYCMVDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:03:30 -0400
Date: Thu, 13 Mar 2008 14:02:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       mhoffman@lightlink.com
Subject: Re: [PATCH] ibmpex: Correct power use multipliers for QS2x blade
Message-Id: <20080313140224.85541a85.akpm@linux-foundation.org>
In-Reply-To: <20080313011538.GA5731@tree.beaverton.ibm.com>
References: <20080313011538.GA5731@tree.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 18:15:38 -0700
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> The QS2x blades ships with v2.54 of the firmware, which use the same multiplier
> for all power meters.
> 

Mark has been quiet lately, so I'll scoot these two into 2.6.25.
