Return-Path: <linux-kernel-owner+w=401wt.eu-S938951AbXFHLOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938951AbXFHLOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937466AbXFHLNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:13:51 -0400
Received: from canuck.infradead.org ([209.217.80.40]:40766 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934345AbXFHLNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:13:51 -0400
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
	used
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <1181133010.4096.26.camel@pmac.infradead.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
	 <1181133010.4096.26.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 12:13:40 +0100
Message-Id: <1181301220.2801.24.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 13:30 +0100, David Woodhouse wrote:
> +               printk("No relevant change\n");

Oops, that wasn't supposed to sneak into the final patch. I'll send a
new one.

-- 
dwmw2

