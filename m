Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbYFIJsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbYFIJsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbYFIJsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:48:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001AbYFIJs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:48:29 -0400
Date: Mon, 9 Jun 2008 02:48:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com
Subject: Re: Version 2: [PATCH 2/3] ACPI: Send switch event on dock events
Message-Id: <20080609024823.a8387821.akpm@linux-foundation.org>
In-Reply-To: <20080529082202.GD16444@srcf.ucam.org>
References: <20080528130621.GA32646@srcf.ucam.org>
	<20080528132152.GB32646@srcf.ucam.org>
	<20080529082202.GD16444@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 09:22:02 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Send a switch event on docking for consistency with docks that don't 
> present as a separate device.

It oopses: http://userweb.kernel.org/~akpm/p6096540.jpg

http://userweb.kernel.org/~akpm/config-t61p.txt
