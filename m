Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbZBRWsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbZBRWsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758596AbZBRWhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:37:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759470AbZBRWhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:37:42 -0500
Date: Wed, 18 Feb 2009 14:36:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mingo@elte.hu, x86@kernel.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       tglx@linutronix.de, rusty@rustcorp.com.au, zach@vmware.com,
       akataria@vmware.com, avi@redhat.com, mtosatti@redhat.com,
       jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH 0/9] Make lazy mmu update mode pre-empt safe
Message-Id: <20090218143616.ed8f0966.akpm@linux-foundation.org>
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 14:30:10 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This series changes the paravirt-ops lazy update modes in the following ways:

glumph.  This doesn't look like a 2.6.29 quickfix.
