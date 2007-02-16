Return-Path: <linux-kernel-owner+w=401wt.eu-S1422955AbXBPAp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422955AbXBPAp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422956AbXBPAp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:45:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40934 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422955AbXBPAp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:45:56 -0500
Date: Thu, 15 Feb 2007 16:45:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@debian.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [patch 1/3] Input: psmouse - create PS/2 protocol options for
 Kconfig
Message-Id: <20070215164553.28f3f9af.akpm@linux-foundation.org>
In-Reply-To: <45D43115.6060806@debian.org>
References: <45D43115.6060806@debian.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 05:08:21 -0500
Andres Salomon <dilinger@debian.org> wrote:

> Initial framework for disabling PS/2 protocol extensions.  The current
> protocols can only be disabled if CONFIG_EMBEDDED is selected.  No
> source files are changed, merely build stuff.

ugleee.  What benefit do we get for all this additional maintenance burden?
