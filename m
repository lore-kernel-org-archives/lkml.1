Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbZDIORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbZDIORQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZDIOQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:16:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44623 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZDIOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:16:58 -0400
Date: Thu, 9 Apr 2009 09:04:56 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] namespaces: Move get_mq() inside #ifdef CONFIG_SYSCTL
Message-ID: <20090409140456.GB26467@us.ibm.com>
References: <alpine.LRH.2.00.0904091203370.771@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0904091203370.771@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Geert Uytterhoeven (Geert.Uytterhoeven@sonycom.com):
> | ipc/mq_sysctl.c:26: warning: 'get_mq' defined but not used
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Yup

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge
