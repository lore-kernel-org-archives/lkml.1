Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYE2XqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYE2XqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYE2XqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:46:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbYE2XqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:46:05 -0400
Date: Thu, 29 May 2008 16:45:54 -0700
From: Andrew Morton <akpm@linuxfoundation.org>
To: alexander@comm.utoronto.ca
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] usbhid: Fix fn key on Macbook Pro 4,1 and Macbook Air
Message-Id: <20080529164554.0d3b6606.akpm@linux-foundation.org>
In-Reply-To: <36765.142.151.170.214.1212101197.squirrel@webmail.comm.utoronto.ca>
References: <36765.142.151.170.214.1212101197.squirrel@webmail.comm.utoronto.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 18:46:37 -0400 (EDT)
alexander@comm.utoronto.ca wrote:

> Added device ids to hid-quriks for detection of keyboards on 4th generation Macbook Pro and Macbook Air

Thanks.

Jiri, I'll assume this this is destined for your tree.  Perhaps
suitable for 2.6.26?   I can merge it at your request, as always.

