Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbXKUShw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbXKUShw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXKUSho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:37:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48976 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbXKUShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:37:43 -0500
Date: Wed, 21 Nov 2007 10:34:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] Add the word 'Warning' in check_nmi_watchdog() output
Message-ID: <20071121103459.0b9b0302@laptopd505.fenrus.org>
In-Reply-To: <1195665260-14641-1-git-send-email-dzickus@redhat.com>
References: <1195665260-14641-1-git-send-email-dzickus@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 12:14:20 -0500
Don Zickus <dzickus@redhat.com> wrote:

> Our automated test suite looks for keywords like error, fail, warning
> in the boot log.  In the case when the nmi watchdog is determined to
> be stuck in check_nmi_watchdog(), none of those keywords are
> displayed.


please make it at least consistent with the other kernel level bad
things, and use "WARNING:"....
