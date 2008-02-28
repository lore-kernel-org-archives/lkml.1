Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYB1FXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYB1FXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 00:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYB1FXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 00:23:33 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781AbYB1FXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 00:23:32 -0500
Date: Wed, 27 Feb 2008 21:22:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Linux Kernel Markers - if check format
Message-Id: <20080227212206.6bafa613.akpm@linux-foundation.org>
In-Reply-To: <20080228045433.GA32364@Krystal>
References: <20080228045433.GA32364@Krystal>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 23:54:33 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Subject: [PATCH] Linux Kernel Markers - if check format

err, that's not very comprehensible.  I changed it to "markers: add an
if(0) to __mark_check_format()".

I think "Linux Kernel Markers" is an excessivelt elaborate subsystem
identifier, btw.   Plain old "markers" will suffice ;)

