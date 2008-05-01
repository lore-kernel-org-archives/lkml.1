Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYEBGuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYEBGuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 02:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYEBGua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 02:50:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYEBGua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 02:50:30 -0400
Date: Thu, 1 May 2008 01:50:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andres Freund <andres@anarazel.de>
Cc: linux-kernel@vger.kernel.org, apdim@grecian.net,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] v4l/dvb: Add linux/version.h include as KERNEL_VERSION
 macro is used.
Message-ID: <20080501015003.4b7a9058@infradead.org>
In-Reply-To: <200805012005.42400.andres@anarazel.de>
References: <200805012005.42400.andres@anarazel.de>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 20:05:41 +0200
Andres Freund <andres@anarazel.de> wrote:

> Whitout this build fails with unknown macro on 
> e4c576b911e364737b1bf4f5bfdab1c440713f26
> 
> Hopefully I did everything correct, as this is my first usage of git
> beside checking out. Also its my first patch on lk....
> 
> Is an Signed-off-by already appropriate with such an trivial change?
> 

Hi,

maybe the real fix is to remove the use of KERNEL_VERSION in this code??

Greetings,
   Arjan van de Ven
