Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYJ3Gon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYJ3Gon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 02:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYJ3Gof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 02:44:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbYJ3Goe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 02:44:34 -0400
Date: Wed, 29 Oct 2008 23:43:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marton Balint <cus@fazekas.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block:do_mounts - add device info to mount message
Message-Id: <20081029234356.aa1a3760.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0810241309190.31107@cinke.fazekas.hu>
References: <Pine.LNX.4.64.0810241309190.31107@cinke.fazekas.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 13:31:53 +0200 (CEST) Marton Balint <cus@fazekas.hu> wrote:

> Printing the minor and major number of the successfully mounted root 
> device can be quite useful, the patch adds this piece of information 
> to the "VFS: Mounted root..." message.
> 

Can you expand upon "quite useful", please?  In what way is it useful? 
A real-world example would help.

