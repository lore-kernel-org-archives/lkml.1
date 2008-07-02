Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYGBJeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYGBJeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYGBJeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:34:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbYGBJeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:34:02 -0400
Date: Wed, 2 Jul 2008 02:33:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arthur Jones <ajones@riverbed.com>
Cc: dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/edac: i5100_edac cleanup
Message-Id: <20080702023345.2554ef15.akpm@linux-foundation.org>
In-Reply-To: <20080630195612.GA17211@ajones-laptop.nbttech.com>
References: <20080630195612.GA17211@ajones-laptop.nbttech.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i386 allmodconfig:

drivers/edac/i5100_edac.c:258: warning: function declaration isn't a prototype
drivers/edac/i5100_edac.c:263: warning: function declaration isn't a prototype
drivers/edac/i5100_edac.c: In function 'i5100_ctl_page_to_phys':
drivers/edac/i5100_edac.c:372: warning: left shift count >= width of type       
