Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbZANXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbZANXZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 18:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZANXZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 18:25:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268AbZANXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 18:25:00 -0500
Date: Wed, 14 Jan 2009 15:24:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lenb@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz
Subject: Re: [PATCH] resume: wait for device probing to finish
Message-Id: <20090114152444.64e1ddfb.akpm@linux-foundation.org>
In-Reply-To: <200901142303.46166.rjw@sisk.pl>
References: <200901142303.46166.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 23:03:45 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> +		wait_for_device_probe();

I don't have this function?
