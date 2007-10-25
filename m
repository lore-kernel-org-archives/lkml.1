Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbXJYDyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbXJYDyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbXJYDyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:54:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756566AbXJYDyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:54:12 -0400
Date: Wed, 24 Oct 2007 20:53:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: trenn@suse.de
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [Fwd: [PATCH 3/5] Export acpi_check_resource_conflict]
Message-Id: <20071024205347.6948c081.akpm@linux-foundation.org>
In-Reply-To: <1193236387.4590.230.camel@queen.suse.de>
References: <1193236387.4590.230.camel@queen.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 16:33:07 +0200 Thomas Renninger <trenn@suse.de> wrote:

> From: Thomas Renninger <trenn@suse.de>
> To: linux-acpi <linux-acpi@vger.kernel.org>
> Cc: linux-kernel <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jean Delvare <khali@linux-fr.org>
> Reply-To: trenn@suse.de
> Subject: [Fwd: [PATCH 3/5] Export acpi_check_resource_conflict]
> Date: Wed, 24 Oct 2007 16:33:07 +0200
> Organization: Novell/SUSE
> X-Mailer: Evolution 2.8.2 
> 
> Export acpi_check_resource_conflict(), sometimes drivers already have
> a struct resource at hand so no need to use the wrappers to build a new
> one.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> ---

The attributions on this are all mucked up.

I _think_ it was written by Jean, in which case the changlog should
have had From:him right at the start to indicate this.  And as you
were in the delivery path, it should have had your signoff.

I'll make those changes - please let me know if I misguessed.
