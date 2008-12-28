Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbYL1GWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbYL1GWI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 01:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYL1GVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 01:21:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbYL1GVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 01:21:54 -0500
Date: Sat, 27 Dec 2008 22:21:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: 2.6.28 thinks that my PS/2 mouse is a touchpad
Message-Id: <20081227222152.fdb4bf23.akpm@linux-foundation.org>
In-Reply-To: <gj4r8h$okm$1@ger.gmane.org>
References: <gj4r8h$okm$1@ger.gmane.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2008 14:06:29 +0500 "Alexander E. Patrakov" <patrakov@gmail.com> wrote:

> Linux-2.6.28, as compiled by Arch Linux developers, thinks that my PS/2 mouse (a cheap M-BT58 optical wheel mouse by Logitech) is actually a touchpad. This makes it unusable. Adding the "proto=imps" parameter to the psmouse module helps.
> 
> Dmesg output and config are attached.

(cc linux-input)
