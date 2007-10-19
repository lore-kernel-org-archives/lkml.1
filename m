Return-Path: <linux-kernel-owner+w=401wt.eu-S966948AbXJSVQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966948AbXJSVQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760932AbXJSVQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:16:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759672AbXJSVQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:16:42 -0400
Date: Fri, 19 Oct 2007 14:16:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] drivers-edac-add freescale mpc85xx driver
Message-Id: <20071019141633.83f7b658.akpm@linux-foundation.org>
In-Reply-To: <47190313.ydKOrijZHK53mNpJ%dougthompson@xmission.com>
References: <47190313.ydKOrijZHK53mNpJ%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 13:18:43 -0600
dougthompson@xmission.com wrote:

> From: Dave Jiang <djiang@mvista.com>
> 
> EDAC chip driver support for Freescale MPC85xx platforms. PPC based. 
> 
> ...
> +
> +const char *mpc85xx_ctl_name = "MPC85xx";

I can't tell whether this should have had static scope because nothing uses
it ;)


